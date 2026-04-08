//
//  FolderPlayer.swift
//  FolderMusicPlayerLite
//
//  Created by 栫 義明 on 2026/04/07.
//
//再生ロジック（シャッフル・リピート含む）
//
//  FolderPlayer.swift
//  FolderMusicPlayerLite
//
//  Created by 栫 義明 on 2026/04/07.
//
//再生ロジック（シャッフル・リピート含む）
import Foundation
import AVFoundation
import Combine
import AppKit

@MainActor
class FolderPlayer: NSObject, ObservableObject {
    static let shared = FolderPlayer()

    @Published var fileURLs: [URL] = []
    @Published var currentIndex: Int = 0
    @Published var currentTitle: String = ""
    @Published var isShuffle: Bool = false
    @Published var isPlaying: Bool = false

    // ★ スライダー用
    @Published var currentTime: Double = 0
    @Published var duration: Double = 1

    private var timer: Timer?

    enum RepeatMode { case none, one, all }
    @Published var repeatMode: RepeatMode = .none

    var recentFolders: [URL] = []
    var onTitleChange: ((String) -> Void)?

    private var originalOrder: [URL] = []

    // AVAudioEngine
    private let engine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    private var audioFile: AVAudioFile?
    private var seekStartOffset: Double = 0
    private var lastPlaybackTime: Double = 0
    private var hasHandledPlaybackEnd: Bool = false

    override init() {
        super.init()
        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: nil)
        try? engine.start()
    }

    func selectFolder() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false

        if panel.runModal() == .OK, let url = panel.url {
            loadFiles(in: url)

            recentFolders.removeAll(where: { $0 == url })
            recentFolders.insert(url, at: 0)
            if recentFolders.count > 3 { recentFolders.removeLast() }
        }
    }

    func loadFiles(in folderURL: URL) {
        let fm = FileManager.default
        let exts = ["mp3", "m4a", "wav", "aac", "flac"]

        let files = (try? fm.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)) ?? []

        fileURLs = files
            .filter { exts.contains($0.pathExtension.lowercased()) }
            .sorted { $0.lastPathComponent < $1.lastPathComponent }

        originalOrder = fileURLs
        currentIndex = 0
        playCurrent()
    }

    func playCurrent() {
        guard fileURLs.indices.contains(currentIndex) else { return }
        let url = fileURLs[currentIndex]

        currentTitle = url.lastPathComponent
        onTitleChange?(currentTitle)

        playerNode.stop()
        timer?.invalidate()
        hasHandledPlaybackEnd = false

        DispatchQueue.global().async {
            guard let file = try? AVAudioFile(forReading: url) else { return }

            DispatchQueue.main.async {
                self.audioFile = file
                self.duration = Double(file.length) / file.processingFormat.sampleRate
                self.seekStartOffset = 0
                self.currentTime = 0
                self.startEnginePlayback()
                self.startTimer()
            }
        }
    }

    private func startEnginePlayback() {
        guard let file = audioFile else { return }

        playerNode.stop()

        // ★ 初回再生は 0 秒から
        let frameCount = AVAudioFrameCount(file.length)
        playerNode.scheduleSegment(
            file,
            startingFrame: 0,
            frameCount: frameCount,
            at: nil
        )

        if !engine.isRunning {
            try? engine.start()
        }

        playerNode.play()
        isPlaying = true
        lastPlaybackTime = 0
        hasHandledPlaybackEnd = false
    
    }


    func togglePlayPause() {
        if playerNode.isPlaying {
            playerNode.pause()
            isPlaying = false
        } else {
            playerNode.play()
            isPlaying = true
        }
    }

    func next() {
        currentIndex = (currentIndex + 1) % fileURLs.count
        playCurrent()
    }

    func previous() {
        currentIndex = (currentIndex - 1 + fileURLs.count) % fileURLs.count
        playCurrent()
    }

    func jump(to index: Int) {
        currentIndex = index
        playCurrent()
    }

    func toggleShuffle() {
        isShuffle.toggle()

        if isShuffle {
            originalOrder = fileURLs
            fileURLs.shuffle()
        } else {
            fileURLs = originalOrder
        }

        if let url = audioFile?.url,
           let newIndex = fileURLs.firstIndex(of: url) {
            currentIndex = newIndex
        }
    }

    // ★★★★★ スライダー用：現在位置を更新するタイマー
    private func startTimer() {
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            Task { @MainActor in
                guard let nodeTime = self.playerNode.lastRenderTime,
                      let playerTime = self.playerNode.playerTime(forNodeTime: nodeTime) else { return }

                let seconds = Double(playerTime.sampleTime) / playerTime.sampleRate + self.seekStartOffset
                self.currentTime = seconds
                self.lastPlaybackTime = seconds
                
                // 再生終了検出（一度だけ実行）
                if !self.hasHandledPlaybackEnd && self.isPlaying && seconds >= self.duration - 0.1 && self.duration > 1 {
                    self.hasHandledPlaybackEnd = true
                    self.handlePlaybackEnd()
                }
            }
        }
    }


    // ★★★★★ スライダー用：シーク（早送り・巻き戻し）
    func seek(to time: Double) {
        guard let file = audioFile else { return }

        let wasPlaying = playerNode.isPlaying
        playerNode.stop()

        seekStartOffset = time
        lastPlaybackTime = time
        hasHandledPlaybackEnd = false

        let sampleRate = file.processingFormat.sampleRate
        let frame = AVAudioFramePosition(time * sampleRate)
        let remainingFrames = AVAudioFrameCount(file.length - frame)

        guard remainingFrames > 0 else {
            currentTime = time
            isPlaying = false
            return
        }

        playerNode.scheduleSegment(
            file,
            startingFrame: frame,
            frameCount: remainingFrames,
            at: nil
        )

        if wasPlaying {
            playerNode.play()
        }

        currentTime = time
        isPlaying = wasPlaying
    }


    // ★★★★★ 時間表示用
    func timeString(_ sec: Double) -> String {
        let m = Int(sec) / 60
        let s = Int(sec) % 60
        return String(format: "%d:%02d", m, s)
    }

    func toggleRepeatMode() {
        switch repeatMode {
        case .none:
            repeatMode = .one
        case .one:
            repeatMode = .all
        case .all:
            repeatMode = .none
        }
    }

    private func playbackEnded() {
        guard audioFile != nil else { return }

        switch repeatMode {
        case .none:
            next()
        case .one:
            seek(to: 0)
            if playerNode.isPlaying {
                playerNode.play()
            }
        case .all:
            if currentIndex == fileURLs.count - 1 {
                currentIndex = 0
                playCurrent()
            } else {
                next()
            }
        }
    }

    private func handlePlaybackEnd() {
        playbackEnded()
    }
}

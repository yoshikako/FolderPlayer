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

    enum RepeatMode { case none, one, all }
    @Published var repeatMode: RepeatMode = .none

    var recentFolders: [URL] = []
    var onTitleChange: ((String) -> Void)?

    private var originalOrder: [URL] = []

    // AVAudioEngine 版
    private let engine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    private var audioFile: AVAudioFile?

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

        // 既存の再生を停止
        playerNode.stop()

        // 非同期で FLAC を読み込み（高速）
        DispatchQueue.global().async {
            guard let file = try? AVAudioFile(forReading: url) else { return }

            DispatchQueue.main.async {
                self.audioFile = file
                self.startEnginePlayback()
            }
        }
    }

    private func startEnginePlayback() {
        guard let file = audioFile else { return }

        playerNode.stop()
        playerNode.scheduleFile(file, at: nil)

        if !engine.isRunning {
            try? engine.start()
        }

        playerNode.play()
        isPlaying = true
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
}



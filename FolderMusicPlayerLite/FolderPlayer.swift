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


class FolderPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    static let shared = FolderPlayer()

    @Published var fileURLs: [URL] = []
    @Published var currentIndex: Int = 0
    @Published var currentTitle: String = ""
    @Published var isShuffle: Bool = false
    @Published var isPlaying: Bool = false // 追加: 再生状態

    enum RepeatMode { case none, one, all }
    @Published var repeatMode: RepeatMode = .none

    var recentFolders: [URL] = []
    var onTitleChange: ((String) -> Void)?

    private var originalOrder: [URL] = []
    private var player: AVAudioPlayer?

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
        let exts = ["mp3", "m4a", "wav", "aac","flac"]

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

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.play()
            isPlaying = true
        } catch {
            print("play error:", error)
            isPlaying = false
        }
    }

    func togglePlayPause() {
        if player?.isPlaying == true {
            player?.pause()
            isPlaying = false
        } else {
            player?.play()
            isPlaying = true
        }
    }

    func next() {
        if currentIndex + 1 < fileURLs.count {
            currentIndex += 1
        } else {
            currentIndex = 0
        }
        playCurrent()
    }

    func previous() {
        if currentIndex > 0 { currentIndex -= 1 }
        else { currentIndex = fileURLs.count - 1 }
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

        if let url = player?.url,
           let newIndex = fileURLs.firstIndex(of: url) {
            currentIndex = newIndex
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        switch repeatMode {
        case .one: playCurrent()
        case .all: next()
        case .none: next()
        }
    }
}



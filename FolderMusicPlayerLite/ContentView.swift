//
//  ContentView.swift
//  FolderMusicPlayerLite
//
//  Created by 栫 義明 on 2026/04/07.
//
//メインUI（フォルダ選択・プレイリスト）
import SwiftUI
import Combine
struct ContentView: View {
    @EnvironmentObject var player: FolderPlayer

    var body: some View {
        VStack(spacing: 16) {

            Button("フォルダを選択") {
                player.selectFolder()
            }

            HStack(spacing: 20) {
                Button("⏮") { player.previous() }
                Button(player.isPlaying ? "❚❚" : "▶︎") { player.togglePlayPause() }
                Button("⏭") { player.next() }
            }

            HStack {
                Button(action: { player.toggleShuffle() }) {
                    Image(systemName: player.isShuffle ? "shuffle.circle.fill" : "shuffle.circle")
                }

                Button(action: {
                    switch player.repeatMode {
                    case .none: player.repeatMode = .all
                    case .all: player.repeatMode = .one
                    case .one: player.repeatMode = .none
                    }
                }) {
                    Image(systemName: {
                        switch player.repeatMode {
                        case .none: return "repeat"
                        case .all: return "repeat.circle.fill"
                        case .one: return "repeat.1.circle.fill"
                        }
                    }())
                }
            }

            Divider()

            Text("再生中: \(player.currentTitle)")
                .font(.headline)

            Divider()

            List {
                ForEach(Array(player.fileURLs.enumerated()), id: \.element) { index, url in
                    HStack {
                        Text(url.lastPathComponent)
                            .foregroundColor(index == player.currentIndex ? .blue : .primary)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        player.jump(to: index)
                    }
                }
            }
        }
        .padding()
        .frame(width: 400, height: 500)
    }
}

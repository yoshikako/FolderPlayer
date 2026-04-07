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
        VStack(spacing: 12) {

            // フォルダ選択ボタン（小さめ・上品）
            Button(action: {
                player.selectFolder()
            }) {
                Text("Select Folder")
                    .font(.system(size: 15, weight: .semibold))
            }
            .buttonStyle(.bordered)
            .controlSize(.regular)

            // 再生コントロール
            HStack(spacing: 16) {
                Button(action: { player.previous() }) {
                    Image(systemName: "backward.fill")
                        .font(.system(size: 20))
                }

                Button(action: { player.togglePlayPause() }) {
                    Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 26))
                }

                Button(action: { player.next() }) {
                    Image(systemName: "forward.fill")
                        .font(.system(size: 20))
                }
            }

            // シャッフル・リピート
            HStack(spacing: 20) {
                Button(action: { player.toggleShuffle() }) {
                    Image(systemName: player.isShuffle ? "shuffle.circle.fill" : "shuffle.circle")
                        .font(.system(size: 22))
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
                    .font(.system(size: 22))
                }
            }

            Divider()

            Text("Loading: \(player.currentTitle)")
                .font(.system(size: 14, weight: .medium))
                .padding(.top, 2)

            Divider()

            // プレイリスト
            List {
                ForEach(Array(player.fileURLs.enumerated()), id: \.element) { index, url in
                    HStack {
                        Text(url.lastPathComponent)
                            .font(.system(size: 13))
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
        .padding(12)
        .frame(width: 360, height: 480)   // ← 最適サイズ
    }
}

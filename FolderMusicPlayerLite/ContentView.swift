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
    @State private var isDraggingSlider = false
    @State private var dragTime: Double = 0

    var body: some View {
        VStack(spacing: 10) {

            // フォルダ選択ボタン
            Button(action: {
                player.selectFolder()
            }) {
                Text("Select Folder")
                    .font(.system(size: 14, weight: .semibold))
            }
            .buttonStyle(.bordered)
            .controlSize(.small)

            // 再生コントロール
            HStack(spacing: 14) {
                Button(action: { player.previous() }) {
                    Image(systemName: "backward.fill")
                        .font(.system(size: 18))
                }

                Button(action: { player.togglePlayPause() }) {
                    Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 24))
                }

                Button(action: { player.next() }) {
                    Image(systemName: "forward.fill")
                        .font(.system(size: 18))
                }
            }

            // ★★★ 再生位置スライダー ★★★
            Slider(
                value: Binding(
                    get: {
                        isDraggingSlider ? dragTime : player.currentTime
                    },
                    set: { newValue in
                        dragTime = newValue
                    }
                ),
                in: 0...max(player.duration, 1),
                onEditingChanged: { editing in
                    if editing {
                        isDraggingSlider = true
                        dragTime = player.currentTime
                    } else {
                        player.seek(to: dragTime)
                        isDraggingSlider = false
                    }
                }
            )
            .padding(.horizontal, 6)

            // 時間表示（任意）
            HStack {
                Text(player.timeString(player.currentTime))
                    .font(.system(size: 11))
                Spacer()
                Text(player.timeString(player.duration))
                    .font(.system(size: 11))
            }
            .padding(.horizontal, 6)

            // シャッフル・リピート
            HStack(spacing: 18) {
                Button(action: { player.toggleShuffle() }) {
                    Image(systemName: player.isShuffle ? "shuffle.circle.fill" : "shuffle.circle")
                        .font(.system(size: 20))
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
                    .font(.system(size: 20))
                }
            }

            Divider()

            Text("Loading: \(player.currentTitle)")
                .font(.system(size: 13, weight: .medium))
                .padding(.top, 2)

            Divider()

            // プレイリスト
            List {
                ForEach(Array(player.fileURLs.enumerated()), id: \.element) { index, url in
                    HStack {
                        Text(url.lastPathComponent)
                            .font(.system(size: 12))
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
        .padding(10)
        .frame(width: 320, height: 440)
    }
}

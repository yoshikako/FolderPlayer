import SwiftUI
import Combine

struct ContentView: View {
    @EnvironmentObject var player: FolderPlayer

    var body: some View {
        VStack(spacing: 10) {

            // ① Folder ボタン（右端）＋ 下の余白を広く
            HStack {
                Spacer()
                Button(action: {
                    player.selectFolder()
                }) {
                    Text("Folder")
                        .font(.system(size: 14, weight: .semibold))
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
            .padding(.bottom, 8)   // ← 間隔を広くするポイント

            // ② 曲名を枠（窓）付きで表示
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    .frame(height: 28)

                Text(player.currentTitle)
                    .font(.system(size: 15, weight: .semibold))
                    .lineLimit(1)
                    .padding(.horizontal, 6)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 4)

            // ③ スライダー（細く）
            VStack(spacing: 2) {
                Slider(
                    value: Binding(
                        get: { player.currentTime },
                        set: { newValue in player.seek(to: newValue) }
                    ),
                    in: 0...max(player.duration, 1)
                )
                .controlSize(.mini)        // ← 細くする
                .tint(.gray.opacity(0.8))  // ← 色も控えめに
                .padding(.horizontal, 6)

                HStack {
                    Text(player.timeString(player.currentTime))
                        .font(.system(size: 11))
                    Spacer()
                    Text(player.timeString(player.duration))
                        .font(.system(size: 11))
                }
                .padding(.horizontal, 6)
            }

            // ④ 前の曲・再生/停止・次の曲（さらに間隔を狭く）
            HStack(spacing: 12) {
                Button(action: { player.previous() }) {
                    Image(systemName: "backward.end")
                        .font(.system(size: 16))   // ← 微調整
                }

                Button(action: { player.togglePlayPause() }) {
                    Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 22))   // ← 少し小さくして上品に
                }

                Button(action: { player.next() }) {
                    Image(systemName: "forward.end")
                        .font(.system(size: 16))   // ← 微調整
                }
            }
            .padding(.top, -2)   // ← スライダーとの距離をさらに縮める

            // ⑤ ランダム・リピート
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

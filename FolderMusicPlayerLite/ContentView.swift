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

            Button(action: {
                player.selectFolder()
            }) {
                Text("Selsct Folder")
                    .font(.system(size: 18, weight: .semibold))
            }
            .buttonStyle(.plain)   // ← 余計な装飾を消す


            
//            HStack(spacing: 20) {
//                Button("⏮") { player.previous() }
//                Button(player.isPlaying ? "❚❚" : "▶︎") { player.togglePlayPause() }
//                Button("⏭") { player.next() }
//            }

            
            HStack(spacing: 20) {
                Button(action: { player.previous() }) {
                    Image(systemName: "backward.fill")
                        .font(.system(size: 22))   // ← さらに少し小さく
                }

                Button(action: { player.togglePlayPause() }) {
                    Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 28))   // ← 中央も控えめに
                }

                Button(action: { player.next() }) {
                    Image(systemName: "forward.fill")
                        .font(.system(size: 22))
                }
            }




            
           
            
    
            HStack {
                Button(action: { player.toggleShuffle() }) {
                    Image(systemName: player.isShuffle ? "shuffle.circle.fill" : "shuffle.circle")
                        .font(.system(size: 26))
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
                    .font(.system(size: 26))
                }
            }

            
            
            
            

            Divider()

            Text("Loading: \(player.currentTitle)")
                .font(.system(size: 16, weight: .semibold))
                .padding(.top, 4)

            Divider()

            List {
                ForEach(Array(player.fileURLs.enumerated()), id: \.element) { index, url in
                    HStack {
                        Text(url.lastPathComponent)
                            .font(.system(size: 14))   // ← ここで大きくする
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
        .frame(width: 400, height: 600)
    }
}

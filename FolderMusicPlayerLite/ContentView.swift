import SwiftUI
import Combine

#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

struct ContentView: View {
    @EnvironmentObject var player: FolderPlayer
    @Environment(\.colorScheme) private var colorScheme
    
    private var mainBackground: Color {
        if colorScheme == .dark {
            #if os(iOS) || targetEnvironment(macCatalyst)
            return Color(.systemBackground)
            #else
            return Color(NSColor.windowBackgroundColor)
            #endif
        } else {
            return Color(red: 0.97, green: 0.96, blue: 0.93)
        }
    }
    
    private var panelBackground: Color {
        if colorScheme == .dark {
            #if os(iOS) || targetEnvironment(macCatalyst)
            return Color(.secondarySystemBackground)
            #else
            return Color(NSColor.windowBackgroundColor).opacity(0.95)
            #endif
        } else {
            return Color(white: 1.0, opacity: 0.95)
        }
    }
    
    private var borderColor: Color {
        if colorScheme == .dark {
            return Color.white.opacity(0.28)
        } else {
            return Color.gray.opacity(0.35)
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            
            // ① Folder ボタン（右上・丸背景・上品デザイン）
            HStack {
                Spacer()
                Button(action: {
                    player.selectFolder()
                }) {
                    Image(systemName: "folder")
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                        .frame(width: 30, height: 30)
                        .background(
                            Circle()
                                .stroke(borderColor, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, 8)
            
            // ② 曲名を枠（窓）付きで表示（背景色＋幅広め）
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(panelBackground)      // ← ダーク/ライト両対応の背景色
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(borderColor, lineWidth: 1)
                    )
                    .frame(height: 30)                   // ← 少し高さも上品に
                    .padding(.horizontal, 2)             // ← 枠そのものを広げる
                
                Text(player.currentTitle)
//                    .font(.system(size: 15, weight: .semibold))
                    .font(.system(size: 15, weight: .regular))   // ← 細くしたい
                    .lineLimit(1)
                    .padding(.horizontal, 10)            // ← 内側の余白を広げる（枠幅UP）
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 6)
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
//              .scaleEffect(y: 0.6, anchor: .center)   // ← ★ これを追加すると細くなる
                 .scaleEffect(x: 1.0, y: 0.55, anchor: .center)   // ← ★ つまみも細く小さく見える

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
            
            // ④ 前の曲・再生/停止・次の曲（デザイン強化版）
            HStack(spacing: 10) {
                
                // 前の曲
                Button(action: { player.previous() }) {
                    Image(systemName: "backward.end")
                        .font(.system(size: 17))
                        .foregroundColor(.primary)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .stroke(borderColor, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                
                // 再生 / 停止
                Button(action: { player.togglePlayPause() }) {
                    Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.primary)
                        .frame(width: 38, height: 38)
                        .background(
                            Circle()
                                .stroke(borderColor, lineWidth: 1.2)
                        )
                }
                .buttonStyle(.plain)
                
                // 次の曲
                Button(action: { player.next() }) {
                    Image(systemName: "forward.end")
                        .font(.system(size: 17))
                        .foregroundColor(.primary)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .stroke(borderColor, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(.top, -2)   // ← スライダーとの距離をさらに縮める
            
            // ⑤ ランダム・リピート（丸背景・統一デザイン）
            HStack(spacing: 14) {
                
                // Shuffle
                Button(action: { player.toggleShuffle() }) {
                    Image(systemName: player.isShuffle ? "shuffle.circle.fill" : "shuffle")
                        .font(.system(size: 18))
                        .foregroundColor(.primary)
                        .frame(width: 30, height: 30)
                        .background(
                            Circle()
                                .stroke(borderColor, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                
                // Repeat
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
                    .font(.system(size: 18))
                    .foregroundColor(.primary)
                    .frame(width: 30, height: 30)
                    .background(
                        Circle()
                            .stroke(borderColor, lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
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
                                            .padding(.vertical, 4)
                                            .listRowBackground(index == player.currentIndex ? Color.blue.opacity(colorScheme == .dark ? 0.18 : 0.08) : Color.clear)
                                            .contentShape(Rectangle())
                                            .onTapGesture {
                                                player.jump(to: index)
                                            }
                                        }
                                    }
                                    .scrollContentBackground(.hidden)
//                                    .background(Color.blue.opacity(0.05))   // ← 全体背景
                                  

                                }
                                .padding(10)
                                .frame(width: 320, height: 440)
//                                .background(Color.blue.opacity(0.05))
                                .background(mainBackground)
        
       

//            ZStack {
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(Color.blue.opacity(0.08))
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 12)
//                            .stroke(Color.blue.opacity(0.12), lineWidth: 1)
//                    )
//
//                List {
//                    ForEach(Array(player.fileURLs.enumerated()), id: \.element) { index, url in
//                        HStack {
//                            Text(url.lastPathComponent)
//                                .font(.system(size: 12))
//                                .foregroundColor(Color.blue.opacity(0.30))
//                            Spacer()
//                        }
//                        .listRowBackground(Color.clear)
//                        .contentShape(Rectangle())
//                        .onTapGesture {
//                            player.jump(to: index)
//                        }
//                    }
//                }
//                .scrollContentBackground(.hidden)
//                .background(Color.clear)
//            }
//            .frame(width: 300, height: 260)   // ← ★ここで横幅を固定（重要）
//            .padding(.horizontal, 10)         // ← 全体幅320の中でちょうど良く収まる

   
    }
    
                    
}



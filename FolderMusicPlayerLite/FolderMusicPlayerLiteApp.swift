//
//  FolderMusicPlayerLiteApp.swift
//  FolderMusicPlayerLite
//
//  Created by 栫 義明 on 2026/04/07.
//
//エントリーポイント
import SwiftUI
import AppKit

@main
struct FolderPlayerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(FolderPlayer.shared)
        }
        .defaultSize(width: 420, height: 520)
        .windowResizability(.contentSize)
        .commands {
            CommandMenu("再生") {
                Button("前の曲") {
                    FolderPlayer.shared.previous()
                }
                .keyboardShortcut(KeyEquivalent(Character(UnicodeScalar(NSF7FunctionKey)!)), modifiers: [])

                Button("再生 / 一時停止") {
                    FolderPlayer.shared.togglePlayPause()
                }
                .keyboardShortcut(KeyEquivalent(Character(UnicodeScalar(NSF8FunctionKey)!)), modifiers: [])

                Button("再生 / 一時停止") {
                    FolderPlayer.shared.togglePlayPause()
                }
                .keyboardShortcut(.space, modifiers: [])

                Button("次の曲") {
                    FolderPlayer.shared.next()
                }
                .keyboardShortcut(KeyEquivalent(Character(UnicodeScalar(NSF9FunctionKey)!)), modifiers: [])

                Divider()

                Button("ミュート") {
                    FolderPlayer.shared.toggleMute()
                }
                .keyboardShortcut(KeyEquivalent(Character(UnicodeScalar(NSF10FunctionKey)!)), modifiers: [])

                Button("音量を下げる") {
                    FolderPlayer.shared.adjustVolume(by: -0.1)
                }
                .keyboardShortcut(KeyEquivalent(Character(UnicodeScalar(NSF11FunctionKey)!)), modifiers: [])

                Button("音量を上げる") {
                    FolderPlayer.shared.adjustVolume(by: 0.1)
                }
                .keyboardShortcut(KeyEquivalent(Character(UnicodeScalar(NSF12FunctionKey)!)), modifiers: [])

                Divider()

                Button("次の曲") {
                    FolderPlayer.shared.next()
                }
                .keyboardShortcut(.rightArrow, modifiers: .command)

                Button("前の曲") {
                    FolderPlayer.shared.previous()
                }
                .keyboardShortcut(.leftArrow, modifiers: .command)

                Button("音量を上げる") {
                    FolderPlayer.shared.adjustVolume(by: 0.1)
                }
                .keyboardShortcut(.upArrow, modifiers: .command)

                Button("音量を下げる") {
                    FolderPlayer.shared.adjustVolume(by: -0.1)
                }
                .keyboardShortcut(.downArrow, modifiers: .command)
            }
        }

        Settings {
            SettingsView()
                .environmentObject(FolderPlayer.shared)
                .frame(width: 300, height: 200)
               }
    }
}








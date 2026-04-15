//
//  FolderMusicPlayerLiteApp.swift
//  FolderMusicPlayerLite
//
//  Created by 栫 義明 on 2026/04/07.
//
//エントリーポイント
import SwiftUI

@main
struct FolderMusicPlayerLiteApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {

        // メインウィンドウは AppDelegate が管理するため空でOK
        WindowGroup {
            EmptyView()
        }

        // Settings メニューは必ず中身を持たせる
        Settings {
            SettingsView()
        }
    }
}



//
//  FolderMusicPlayerLiteApp.swift
//  FolderMusicPlayerLite
//
//  Created by 栫 義明 on 2026/04/07.
//
//エントリーポイント
import SwiftUI
import SwiftData

@main
struct FolderMusicPlayerLiteApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}


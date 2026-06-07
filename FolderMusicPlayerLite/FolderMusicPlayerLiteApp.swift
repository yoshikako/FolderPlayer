//
//  FolderMusicPlayerLiteApp.swift
//  FolderMusicPlayerLite
//
//  Created by 栫 義明 on 2026/04/07.
//
//エントリーポイント
import SwiftUI

@main
struct FolderPlayerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var adRemoval = AdRemovalManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(FolderPlayer.shared)
                .environmentObject(adRemoval)
        }
        .defaultSize(width: 420, height: 520)
        .windowResizability(.contentSize)

        Settings {
            SettingsView()
                .environmentObject(FolderPlayer.shared)
                .environmentObject(adRemoval)
                .frame(width: 300, height: 240)
        }
    }
}








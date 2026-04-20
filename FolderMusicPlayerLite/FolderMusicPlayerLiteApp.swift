//
//  FolderMusicPlayerLiteApp.swift
//  FolderMusicPlayerLite
//
//  Created by 栫 義明 on 2026/04/07.
//
//エントリーポイント
import SwiftUI

//@main
//struct FolderMusicPlayerLiteApp: App {
//    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//
//    var body: some Scene {
//        Settings {
//            SettingsView()
//        }
//    }
//}
@main
struct FolderPlayerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(FolderPlayer.shared)
        }
        
        .windowResizability(.contentSize)
        .defaultSize(width: 420, height: 520)
        

        Settings {
            SettingsView()
        }
    }
}









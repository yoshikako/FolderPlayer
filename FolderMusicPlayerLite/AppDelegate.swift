//
//  AppDelegate.swift
//  FolderMusicPlayerLite
//
//  Created by 栫 義明 on 2026/04/07.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var window: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // メニューバーアイコン
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.image = NSImage(systemSymbolName: "folder.fill.badge.music", accessibilityDescription: nil)

        // メニュー
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "再生/停止", action: #selector(togglePlayPause), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "次の曲", action: #selector(nextTrack), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "前の曲", action: #selector(previousTrack), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "フォルダを選択", action: #selector(selectFolder), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "ウィンドウを開く", action: #selector(openWindow), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "終了", action: #selector(quitApp), keyEquivalent: "q"))

        statusItem.menu = menu
    }

    // MARK: - Actions
    @objc func togglePlayPause() { FolderPlayer.shared.togglePlayPause() }
    @objc func nextTrack() { FolderPlayer.shared.next() }
    @objc func previousTrack() { FolderPlayer.shared.previous() }
    @objc func selectFolder() { FolderPlayer.shared.selectFolder() }

    @objc func openWindow() {
        if window == nil {
            let contentView = ContentView().environmentObject(FolderPlayer.shared)

           
            
            
            window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 420, height: 520),
                styleMask: [.titled, .closable],
                backing: .buffered,
                defer: false
            )
            
            // ← これが重要（macOS が勝手に resizable を付けるのを防ぐ）
            window?.styleMask.remove(.resizable)

            
            window?.minSize = NSSize(width: 420, height: 520)
            window?.maxSize = NSSize(width: 420, height: 520)


            
            window?.center()
            window?.title = "FolderPlayer"
            window?.contentView = NSHostingView(rootView: contentView)
        }
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc func quitApp() {
        NSApp.terminate(nil)
    }
}

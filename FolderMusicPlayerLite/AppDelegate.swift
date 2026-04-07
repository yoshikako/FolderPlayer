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

        // メニューを空にする（実質メニューなし）
        NSApp.mainMenu = NSMenu()

        if window == nil {
            let contentView = ContentView().environmentObject(FolderPlayer.shared)

            window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 420, height: 520),
                styleMask: [.titled, .closable, .miniaturizable],
                backing: .buffered,
                defer: false
            )

            window?.styleMask.remove(.resizable)
            window?.minSize = NSSize(width: 420, height: 520)
            window?.maxSize = NSSize(width: 420, height: 520)
            window?.center()
            window?.contentView = NSHostingView(rootView: contentView)
            window?.makeKeyAndOrderFront(nil)
        }
    }

}

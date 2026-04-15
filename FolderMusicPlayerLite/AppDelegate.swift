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

        // -------------------------
        // 1. メインメニューを作成
        // -------------------------
        let mainMenu = NSMenu()

        // App メニュー
        let appMenuItem = NSMenuItem()
        mainMenu.addItem(appMenuItem)

        let appMenu = NSMenu()
        appMenuItem.submenu = appMenu

        // Settings…
        appMenu.addItem(
            withTitle: "Settings…",
            action: #selector(openSettings),
            keyEquivalent: ","
        )

        appMenu.addItem(NSMenuItem.separator())

        // バージョン情報
        appMenu.addItem(
            withTitle: "About FolderPlayer",
            action: #selector(showVersionInfo),
            keyEquivalent: ""
        )

        appMenu.addItem(NSMenuItem.separator())

        // Quit
        appMenu.addItem(
            withTitle: "Quit FolderPlayer",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        )

        // Window メニュー
        let windowMenuItem = NSMenuItem()
        mainMenu.addItem(windowMenuItem)

        let windowMenu = NSMenu(title: "Window")
        windowMenuItem.submenu = windowMenu

        windowMenu.addItem(
            withTitle: "Main Window",
            action: #selector(showMainWindow),
            keyEquivalent: "0"
        )

        NSApp.mainMenu = mainMenu


        // -------------------------
        // 2. メインウィンドウ作成
        // -------------------------
        if window == nil {
            let contentView = ContentView().environmentObject(FolderPlayer.shared)

            let win = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 420, height: 520),
                styleMask: [.titled, .closable, .miniaturizable],
                backing: .buffered,
                defer: false
            )

            win.styleMask.remove(.resizable)
            win.center()
            win.contentView = NSHostingView(rootView: contentView)
            win.makeKeyAndOrderFront(nil)

            self.window = win
        }
    }

    // -------------------------
    // Settings を開く
    // -------------------------
    @objc func openSettings() {
        let settingsWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 200),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        settingsWindow.center()
        settingsWindow.title = "Settings"
        settingsWindow.contentView = NSHostingView(rootView: SettingsView())
        settingsWindow.makeKeyAndOrderFront(nil)
    }

    // -------------------------
    // Main Window を再表示
    // -------------------------
    @objc func showMainWindow() {
        window?.makeKeyAndOrderFront(nil)
    }

    // -------------------------
    // バージョン情報
    // -------------------------
    @objc func showVersionInfo() {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"

        let alert = NSAlert()
        alert.messageText = "FolderPlayer バージョン情報"
        alert.informativeText = "Version: \(version)\nBuild: \(build)"
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}

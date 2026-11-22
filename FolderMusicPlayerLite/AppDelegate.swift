//メニュー・ウィンドウ管理・決定版

//import Cocoa
//import SwiftUI
//
//class AppDelegate: NSObject, NSApplicationDelegate {
//    var window: NSWindow?
//
//    func applicationDidFinishLaunching(_ notification: Notification) {
//
//        // -------------------------
//        // 1. メインメニューを作成
//        // -------------------------
//        let mainMenu = NSMenu()
//
//        // App メニュー
//        let appMenuItem = NSMenuItem()
//        mainMenu.addItem(appMenuItem)
//
//        let appMenu = NSMenu()
//        appMenuItem.submenu = appMenu
//
//        appMenu.addItem(withTitle: "Settings…",
//                        action: #selector(openSettings),
//                        keyEquivalent: ",")
//        appMenu.addItem(NSMenuItem.separator())
//        appMenu.addItem(withTitle: "About FolderPlayer",
//                        action: #selector(showVersionInfo),
//                        keyEquivalent: "")
//        appMenu.addItem(NSMenuItem.separator())
//        appMenu.addItem(withTitle: "Quit FolderPlayer",
//                        action: #selector(NSApplication.terminate(_:)),
//                        keyEquivalent: "q")
//
//        // File メニュー（空でOK）
//        let fileMenuItem = NSMenuItem()
//        mainMenu.addItem(fileMenuItem)
//        let fileMenu = NSMenu(title: "File")
//        fileMenuItem.submenu = fileMenu
//
//        // Edit メニュー（空でOK）
//        let editMenuItem = NSMenuItem()
//        mainMenu.addItem(editMenuItem)
//        let editMenu = NSMenu(title: "Edit")
//        editMenuItem.submenu = editMenu
//
//        // Window メニュー
//        let windowMenuItem = NSMenuItem()
//        mainMenu.addItem(windowMenuItem)
//        let windowMenu = NSMenu(title: "Window")
//        windowMenuItem.submenu = windowMenu
//        windowMenu.addItem(withTitle: "Main Window",
//                           action: #selector(showMainWindow),
//                           keyEquivalent: "0")
//
//        // Help メニュー（空でOK）
//        let helpMenuItem = NSMenuItem()
//        mainMenu.addItem(helpMenuItem)
//        let helpMenu = NSMenu(title: "Help")
//        helpMenuItem.submenu = helpMenu
//
//        NSApp.mainMenu = mainMenu
//
//        // -------------------------
//        // 2. メインウィンドウ作成
//        // -------------------------
//        if window == nil {
//            let contentView = ContentView().environmentObject(FolderPlayer.shared)
//
//            let win = NSWindow(
//                contentRect: NSRect(x: 0, y: 0, width: 420, height: 520),
//                styleMask: [.titled, .closable, .miniaturizable],
//                backing: .buffered,
//                defer: false
//            )
//
//            win.styleMask.remove(.resizable)
//            win.center()
//            win.contentView = NSHostingView(rootView: contentView)
//            win.makeKeyAndOrderFront(nil)
//
//            self.window = win
//        }
//    }
//
//    // Dock アイコンクリック時にメインウィンドウを復活
//    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
//        window?.makeKeyAndOrderFront(nil)
//        return true
//    }
//
//    // Settings を開く
//    @objc func openSettings() {
//        let settingsWindow = NSWindow(
//            contentRect: NSRect(x: 0, y: 0, width: 300, height: 200),
//            styleMask: [.titled, .closable],
//            backing: .buffered,
//            defer: false
//        )
//        settingsWindow.center()
//        settingsWindow.title = "Settings"
//        settingsWindow.contentView = NSHostingView(rootView: SettingsView())
//        settingsWindow.makeKeyAndOrderFront(nil)
//    }
//
//    // Main Window を再表示
//    @objc func showMainWindow() {
//        window?.makeKeyAndOrderFront(nil)
//    }
//
//    // バージョン情報
//    @objc func showVersionInfo() {
//        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
//        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
//
//        let alert = NSAlert()
//        alert.messageText = "FolderPlayer バージョン情報"
//        alert.informativeText = "Version: \(version)\nBuild: \(build)"
//        alert.addButton(withTitle: "OK")
//        alert.runModal()
//    }
//}
//import Cocoa
//import SwiftUI
//
//class AppDelegate: NSObject, NSApplicationDelegate {
//    var window: NSWindow?
//
//    func applicationDidFinishLaunching(_ notification: Notification) {
//
//        // -------------------------
//        // メインウィンドウ作成
//        // -------------------------
//        if window == nil {
//            let contentView = ContentView()
//                .environmentObject(FolderPlayer.shared)
//
//            let win = NSWindow(
//                contentRect: NSRect(x: 0, y: 0, width: 420, height: 520),
//                styleMask: [.titled, .closable, .miniaturizable],
//                backing: .buffered,
//                defer: false
//            )
//
//            win.styleMask.remove(.resizable)
//            win.center()
//            win.title = "FolderPlayer"
//            win.contentView = NSHostingView(rootView: contentView)
//            win.makeKeyAndOrderFront(nil)
//
//            self.window = win
//        }
//    }
//
//    // Dockクリックでウィンドウ復活
//    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
//        window?.makeKeyAndOrderFront(nil)
//        return true
//    }
//
//    // ウィンドウ閉じたらアプリ終了（審査対策）
//    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
//        return true
//
//    }
//
//    // メインウィンドウ再表示（必要なら）
//    @objc func showMainWindow() {
//        window?.makeKeyAndOrderFront(nil)
//    }
//
//    // バージョン表示（任意）
//    @objc func showVersionInfo() {
//        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
//        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
//
//        let alert = NSAlert()
//        alert.messageText = "FolderPlayer バージョン情報"
//        alert.informativeText = "Version: \(version)\nBuild: \(build)"
//        alert.addButton(withTitle: "OK")
//        alert.runModal()
//    }
//}

//import Cocoa
//import SwiftUI
//
//class AppDelegate: NSObject, NSApplicationDelegate {
//
//    func applicationDidFinishLaunching(_ notification: Notification) {
//        // 何もしない（SwiftUIに任せる）
//    }
//
//    // ウィンドウ閉じたらアプリ終了（審査対策）
//    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
//        return true
//    }
//}

import Cocoa
import SwiftUI

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    private var keyEventMonitor: Any?

    func applicationDidFinishLaunching(_ notification: Notification) {
        keyEventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let self, self.handleKeyboardShortcut(event) else {
                return event
            }
            return nil
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        if let keyEventMonitor {
            NSEvent.removeMonitor(keyEventMonitor)
        }
    }

    // Dockクリックでウィンドウ復活
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        for window in NSApp.windows {
            window.makeKeyAndOrderFront(nil)
        }
        return true
    }

    // 👇 これを追加（今回の審査対応）
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    private func handleKeyboardShortcut(_ event: NSEvent) -> Bool {
        let modifiers = event.modifierFlags.intersection([.command, .option, .control, .shift])
        let player = FolderPlayer.shared

        if modifiers == .command {
            switch event.keyCode {
            case 123:
                player.previous()
            case 124:
                player.next()
            case 125:
                player.adjustVolume(by: -0.1)
            case 126:
                player.adjustVolume(by: 0.1)
            default:
                return false
            }
            return true
        }

        guard modifiers.isEmpty else { return false }

        switch event.keyCode {
        case 49:
            player.togglePlayPause()
        case 98:
            player.previous()
        case 100:
            player.togglePlayPause()
        case 101:
            player.next()
        case 109:
            player.toggleMute()
        case 103:
            player.adjustVolume(by: -0.1)
        case 111:
            player.adjustVolume(by: 0.1)
        default:
            return false
        }
        return true
    }
}



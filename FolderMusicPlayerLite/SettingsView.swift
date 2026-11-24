//
//  SettingsView.swift
//  FolderMusicPlayerLite
//
//  Created by 栫 義明 on 2026/04/16.
//

//import Foundation
import SwiftUI

struct SettingsView: View {
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }

    var body: some View {
        Form {
            Text("FolderPlayer")
            Text("Version \(appVersion)")
        }
//        .padding()
        .frame(width: 300, height: 200)
    }
}

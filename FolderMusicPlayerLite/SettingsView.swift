//
//  SettingsView.swift
//  FolderMusicPlayerLite
//
//  Created by 栫 義明 on 2026/04/16.
//

//import Foundation
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var adRemoval: AdRemovalManager

    var body: some View {
        Form {
            Section(header: Text("アプリ情報")) {
                Text("FolderPlayer")
                Text("Version 1.0")
            }

            Section(header: Text("広告解除")) {
                if adRemoval.isAdsRemoved {
                    Text("広告は解除されています。ありがとうございます！")
                        .foregroundColor(.green)
                } else {
                    Button(action: {
                        Task {
                            await adRemoval.purchaseRemoveAds()
                        }
                    }) {
                        HStack {
                            Text("広告解除（300円）")
                            Spacer()
                            if adRemoval.isLoading {
                                ProgressView()
                            }
                        }
                    }
                    Button(action: {
                        Task {
                            await adRemoval.restorePurchases()
                        }
                    }) {
                        Text("購入の復元")
                    }
                }

                if let errorMessage = adRemoval.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
            }
        }
        .frame(width: 300, height: 240)
    }
}

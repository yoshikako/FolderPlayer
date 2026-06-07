//
//  SettingsView.swift
//  FolderMusicPlayerLite
//
//  Created by 栫 義明 on 2026/04/16.
//

//import Foundation
//
//  SettingsView.swift
//  FolderMusicPlayerLite
//
//  Created by 栫 義明 on 2026/04/16.
//

//import Foundation
import SwiftUI
import StoreKit

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
                    if let product = adRemoval.product {
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
                        .disabled(adRemoval.isLoading)

                        Text("商品名: \(product.displayName)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("価格: \(product.displayPrice)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else if adRemoval.isProductLoading {
                        Text("商品情報を読み込み中です...")
                            .foregroundColor(.secondary)
                    } else {
                        Text("広告削除商品が読み込めませんでした。設定した product id を確認してください。")
                            .foregroundColor(.red)
                            .font(.footnote)
                    }

                    Button(action: {
                        Task {
                            await adRemoval.restorePurchases()
                        }
                    }) {
                        Text("購入の復元")
                    }
                    .disabled(adRemoval.isLoading)
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

import Foundation
import StoreKit
import SwiftUI
import Combine

@MainActor
class AdRemovalManager: ObservableObject {
    static let shared = AdRemovalManager()

    @Published var isAdsRemoved: Bool = UserDefaults.standard.bool(forKey: AdRemovalManager.userDefaultsKey)
    @Published var isLoading: Bool = false
    @Published var isProductLoading: Bool = false
    @Published var errorMessage: String?
    @Published var product: Product?

    private static let userDefaultsKey = "isAdsRemoved"
    private let productId = "com.foldermusicplayer.removeads"

    init() {
        Task {
            await loadProduct()
            await updatePurchaseStatus()
        }
    }

    func loadProduct() async {
        isProductLoading = true
        defer { isProductLoading = false }

        do {
            let products = try await Product.products(for: [productId])
            self.product = products.first
            if self.product == nil {
                self.errorMessage = "広告削除商品が見つかりません。App Store Connectで product id を確認してください。"
            }
        } catch {
            self.errorMessage = "商品情報の読み込みに失敗しました: \(error.localizedDescription)"
        }
    }

    func purchaseRemoveAds() async {
        guard let product = product else {
            if isProductLoading {
                errorMessage = "商品情報を読み込み中です。しばらく待ってから再度お試しください。"
            } else {
                errorMessage = "広告削除商品が利用できません。App Store Connect の product id を確認してください。"
            }
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                applyPurchase()
            case .pending:
                errorMessage = "購入は保留中です。"
            case .userCancelled:
                break
            @unknown default:
                errorMessage = "不明な購入結果です。"
            }
        } catch {
            errorMessage = "購入に失敗しました: \(error.localizedDescription)"
        }
    }

    func restorePurchases() async {
        isLoading = true
        defer { isLoading = false }

        do {
            try await AppStore.sync()
            await updatePurchaseStatus()
        } catch {
            errorMessage = "購入復元に失敗しました: \(error.localizedDescription)"
        }
    }

    func updatePurchaseStatus() async {
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                if transaction.productID == productId {
                    applyPurchase()
                    return
                }
            } catch {
                continue
            }
        }
    }

    private func applyPurchase() {
        isAdsRemoved = true
        UserDefaults.standard.set(true, forKey: Self.userDefaultsKey)
        errorMessage = nil
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let error):
            throw error
        case .verified(let safeValue):
            return safeValue
        }
    }
}

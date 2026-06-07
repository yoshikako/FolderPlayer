//
//  DummyBannerView.swift
//  FolderMusicPlayerLite
//
//  Created by 栫 義明 on 2026/06/07.
//

import SwiftUI

#if canImport(GoogleMobileAds) && (os(iOS) || targetEnvironment(macCatalyst))
import GoogleMobileAds
import UIKit
#endif

struct AdMobBannerView: View {
    private let adUnitID = "ca-app-pub-1129869943697934/8461201687"
    
    var body: some View {
        #if canImport(GoogleMobileAds) && (os(iOS) || targetEnvironment(macCatalyst))
        AdMobBannerWrapper(adUnitID: adUnitID)
            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
        #else
        HStack {
            Spacer()
            Text("広告バナー（AdMob対応）")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.vertical, 10)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.9), Color.black.opacity(0.85)]), startPoint: .leading, endPoint: .trailing)
        )
        #endif
    }
}

#if canImport(GoogleMobileAds) && (os(iOS) || targetEnvironment(macCatalyst))
private struct AdMobBannerWrapper: UIViewRepresentable {
    let adUnitID: String

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    private static var isAdMobInitialized = false

    func makeUIView(context: Context) -> GADBannerView {
        if !Self.isAdMobInitialized {
            GADMobileAds.sharedInstance().start(completionHandler: nil)
            Self.isAdMobInitialized = true
        }
        let bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = rootViewController()
        bannerView.delegate = context.coordinator
        bannerView.load(GADRequest())
        return bannerView
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {
        if uiView.adUnitID != adUnitID {
            uiView.adUnitID = adUnitID
            uiView.load(GADRequest())
        }
    }

    private func rootViewController() -> UIViewController {
        if let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
           let rootVC = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            return rootVC
        }
        if let rootVC = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            return rootVC
        }
        return UIViewController()
    }

    class Coordinator: NSObject, GADBannerViewDelegate {
    }
}
#endif

struct AdMobBannerView_Previews: PreviewProvider {
    static var previews: some View {
        AdMobBannerView()
            .previewLayout(.sizeThatFits)
    }
}


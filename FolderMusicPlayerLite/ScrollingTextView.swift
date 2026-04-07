
//
//  ScrollingTextView.swift
//  FolderMusicPlayerLite
//
//  Created by 栫 義明 on 2026/04/07.
//
//曲名スクロール表示
import Cocoa

class ScrollingTextView: NSView {
    private let textLayer = CATextLayer()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layer?.masksToBounds = true

        textLayer.alignmentMode = .left
        textLayer.contentsScale = NSScreen.main?.backingScaleFactor ?? 2
        layer?.addSublayer(textLayer)
    }

    required init?(coder: NSCoder) { fatalError() }

    func setText(_ text: String) {
        let width = textWidth(text)
        textLayer.string = text
        textLayer.frame = CGRect(x: 0, y: 0, width: width, height: bounds.height)
        startScroll(width: width)
    }

    private func textWidth(_ text: String) -> CGFloat {
        let attrs = [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 13)]
        return (text as NSString).size(withAttributes: attrs).width
    }

    private func startScroll(width: CGFloat) {
        textLayer.removeAllAnimations()

        guard width > bounds.width else { return }

        let anim = CABasicAnimation(keyPath: "position.x")
        anim.fromValue = bounds.width + width / 2
        anim.toValue = -width / 2
        anim.duration = Double(width) * 0.02
        anim.repeatCount = .infinity

        textLayer.add(anim, forKey: "scroll")
    }
}


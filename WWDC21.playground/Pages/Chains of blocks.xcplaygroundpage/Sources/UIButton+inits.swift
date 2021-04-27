import UIKit

extension UIButton {
    convenience init(title: String, action: UIAction) {
        self.init()
        backgroundColor = .systemBlue
        layer.cornerRadius = 8
        contentEdgeInsets = .init(
            top: 5,
            left: 10,
            bottom: 5,
            right: 10)
        setTitle(
            title,
            for: .normal)
        addAction(
            action,
            for: .touchUpInside)
        setTitleColor(
            .white,
            for: .normal)
        setTitleColor(
            UIColor.white.withAlphaComponent(0.5),
            for: .highlighted)
    }
}

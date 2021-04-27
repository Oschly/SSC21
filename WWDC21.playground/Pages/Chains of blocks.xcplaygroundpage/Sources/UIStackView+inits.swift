import UIKit

extension UIStackView {
    convenience init(subviews: [UIView]) {
        self.init()
        subviews.forEach(addArrangedSubview(_:))
        alignment = .center
        axis = .horizontal
        distribution = .equalSpacing
        spacing = 20
    }
}

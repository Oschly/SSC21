import UIKit

extension UIView {
    func center(in parent: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            centerYAnchor.constraint(equalTo: parent.centerYAnchor),
            centerXAnchor.constraint(equalTo: parent.centerXAnchor)
        ])
    }
    
    func pinToBottom(of parent: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: parent.centerXAnchor),
            heightAnchor.constraint(equalToConstant: 35),
            bottomAnchor.constraint(
                equalTo: parent.safeAreaLayoutGuide.bottomAnchor,
                constant: -40)
        ])
    }
}

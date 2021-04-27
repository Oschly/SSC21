import UIKit

final class BlockRepresentationView: UIView {
    var position: ChainPosition
    let index: Int
    var arrowSublayer: CAShapeLayer? = nil
    let isGenesis: Bool
    let isButton: Bool
    
    init(frame: CGRect, side: ChainPosition, isGenesis: Bool, index: Int, isButton: Bool = false) {
        self.position = side
        self.index = index
        self.isGenesis = isGenesis
        self.isButton = isButton
        super.init(frame: frame)
        backgroundColor = isGenesis ? .genesisBlockColor : .orphanedBlockColor
        layer.borderWidth = 5
        layer.borderColor = UIColor.label.cgColor
    }
    
    required init?(coder: NSCoder) {
        // haha yes
        preconditionFailure("shouldn't happen")
    }
    
    func updateBackground(toColor color: UIColor) {
        guard !isGenesis else { return }
        backgroundColor = color
    }
}

import UIKit

final class ChainController {
    // MARK: Properties
    private let presenter: ChainPresenter
    
    let position: ChainPosition
    let absoluteStartIndex: Int
    var blocks: [BlockRepresentationView] = []
    var distanceFromGenesis: Int { blocks.count + absoluteStartIndex }
    var numberOfBlocks: Int { blocks.count }
    
    let blockSize: CGSize
    let blockVerticalSpacing: CGFloat
    let fullBlockHeight: CGFloat
    let baseXPosition: CGFloat = 20
    
    var appendButton: BlockRepresentationView?
    
    // MARK: - Initializers
    init(absoluteStartIndex: Int, presenter: ChainPresenter, position: ChainPosition) {
        self.presenter = presenter
        self.absoluteStartIndex = absoluteStartIndex
        self.position = position
        
        let blockSide = UIScreen.main.bounds.width * 0.1
        blockSize = CGSize(
            width: blockSide,
            height: blockSide)
        blockVerticalSpacing = blockSide * 0.5
        fullBlockHeight = blockSide + blockVerticalSpacing
        let block = appendBlock()
        
        appendButton = buildAppendBlockButton()
        presenter.append(
            byChain: self,
            blockToScrollView: appendButton!)
        presenter.append(
            byChain: self,
            blockToScrollView: block)
    }
    
    // Initializer for middle chain
    init(presenter: ChainPresenter) {
        self.presenter = presenter
        absoluteStartIndex = 0
        position = .middle
        
        let blockSide = UIScreen.main.bounds.width * 0.1
        blockSize = CGSize(
            width: blockSide,
            height: blockSide)
        blockVerticalSpacing = blockSide * 0.5
        fullBlockHeight = blockSide + blockVerticalSpacing
        
        let genesisBlock = prepareDefaultBlock(withIndex: 0)
        presenter.append(
            byChain: self,
            blockToScrollView: genesisBlock)
        blocks.append(genesisBlock)
        
        appendButton = buildAppendBlockButton()
        presenter.append(
            byChain: self,
            blockToScrollView: appendButton!)
    }
}

// MARK: Blocks related code
extension ChainController {
    func appendBlock() -> BlockRepresentationView {
        let index = CGFloat(distanceFromGenesis)
        let block = prepareDefaultBlock(withIndex: index)
        let blocksCount = blocks.count
        
        var lastBlock: BlockRepresentationView?
        if blocks.isEmpty {
            lastBlock = presenter.blockBehind(index: distanceFromGenesis)
        } else {
            lastBlock = blocks[blocksCount - 1]
        }
        
        blocks.append(block)
        
        guard let unwrappedLastBlock = lastBlock else { return block }
        appendArrow(
            for: block,
            to: unwrappedLastBlock)
        changeButtonsState()
        
        return block
    }
    
    func prepareDefaultBlock(withIndex index: CGFloat, isButton: Bool = false) -> BlockRepresentationView {
        let origin = calculateOrigin(forBlockIndex: index)
        let block = BlockRepresentationView(
            frame: CGRect(
                origin: origin,
                size: blockSize),
            side: position,
            isGenesis: index == 0,
            index: Int(index),
            isButton: isButton)
        return block
    }
    
    func colorOutBlocks(toColor color: UIColor) {
        blocks.forEach { $0.updateBackground(toColor: color) }
    }
    
    func appendArrow(for block: BlockRepresentationView, to previousBlock: BlockRepresentationView) {
        let previousBlockMidY = previousBlock.frame.midY
        let previousBlockMaxX = previousBlock.frame.maxX
        
        let newBlockMinX = block.frame.minX
        let newBlockMidY = block.frame.midY
        
        let newBlockPoint = CGPoint(
            x: newBlockMinX,
            y: newBlockMidY)
        let previousBlockPoint = CGPoint(
            x: previousBlockMaxX,
            y: previousBlockMidY)
        
        let arrow = UIBezierPath.arrow(from: newBlockPoint,
                                       to: previousBlockPoint)
        let arrowLayer = CAShapeLayer(layer: arrow)
        arrowLayer.fillColor = UIColor.label.cgColor
        arrowLayer.path = arrow.cgPath
        
        presenter.append(layerToScrollView: arrowLayer)
        block.arrowSublayer = arrowLayer
    }
}

// MARK: Buttons
extension ChainController {
    func buildAppendBlockButton() -> BlockRepresentationView {
        let block = prepareDefaultBlock(withIndex: CGFloat(distanceFromGenesis), isButton: true)
        block.frame.size = block.frame.size /= 2
        block.frame.origin.y += block.frame.height / 2
        
        block.layer.cornerRadius = block.frame.width / 2
        block.layer.borderColor = UIColor.label.cgColor
        block.updateBackground(toColor: .systemBlue)
        
        let plusImage = UIImage(systemName: "plus",
                                withConfiguration: UIImage.SymbolConfiguration(
                                    pointSize: block.frame.width / 2,
                                    weight: .bold,
                                    scale: .large))
        let plusImageView = UIImageView(image: plusImage)
        plusImageView.tintColor = .white
        block.addSubview(plusImageView)
        plusImageView.center(in: block)
        
        let gesture = UITapGestureRecognizer(
            target: self,
            action: #selector(appendBlockWithUpdate))
        block.addGestureRecognizer(gesture)
        
        return block
    }
    
    @objc func appendBlockWithUpdate() {
        let block = appendBlock()
        presenter.append(
            byChain: self,
            blockToScrollView: block)
        pushAppendButtonIfPossible()
    }
    
    func changeButtonsState() {
        switch position {
        case .middle:
            let canAddUpperChain = presenter.canPutAppendButton(
                onIndex: distanceFromGenesis - 1,
                ofPosition: .upper)
            let canAddBottomChain = presenter.canPutAppendButton(
                onIndex: distanceFromGenesis - 1,
                ofPosition: .bottom)
            
            if canAddUpperChain {
                NotificationCenter.default.post(
                    name: Constants.enableUpperButtonNotification,
                    object: nil)
            }
            if canAddBottomChain {
                NotificationCenter.default.post(
                    name: Constants.enableBottomButtonNotification,
                    object: nil)
            }
            
        case .upper:
            let canAddUpperChain = presenter.mainChain.numberOfBlocks >= distanceFromGenesis
            if !canAddUpperChain {
                NotificationCenter.default.post(
                    name: Constants.disableUpperButtonNotification,
                    object: nil)
            }
            
        case .bottom:
            let canAddBottomChain = presenter.mainChain.numberOfBlocks >= distanceFromGenesis
            if !canAddBottomChain {
                NotificationCenter.default.post(
                    name: Constants.disableBottomButtonNotification,
                    object: nil)
            }
        }
    }
    
    func pushAppendButtonIfPossible() {
        if presenter.canPutAppendButton(
            onIndex: distanceFromGenesis,
            ofPosition: position) {
            appendButton?.frame.origin.x += fullBlockHeight
        } else {
            appendButton?.removeFromSuperview()
            appendButton = nil
        }
    }
}

// MARK: Math
extension ChainController {
    func calculateOrigin(forBlockIndex blockIndex: CGFloat) -> CGPoint {
        let index: CGFloat = {
            switch position {
            case .upper: return -1
            case .middle: return 0
            case .bottom: return 1
            }
        }()
        
        let y = UIScreen.main.bounds.height / 2 + fullBlockHeight * index
        let x = blockSize.height * blockIndex + baseXPosition + blockVerticalSpacing * blockIndex
        
        return CGPoint(x: x, y: y)
    }
}

import UIKit

public final class BlockchainViewController: UIViewController {
    let scrollView = UIScrollView()
    var chains: [ChainController] = []
    var mainChain: ChainController!
    
    var upperChainButton: UIButton!
    var bottomChainButton: UIButton!
    var previousXOffset: CGFloat = 0
}

extension BlockchainViewController: ChainPresenter {
    var frame: CGRect { view.frame }
    
    func blockBehind(index: Int) -> BlockRepresentationView {
        let previousBlockIndex = Int(index - 1)
        let firstChain = chains.first!
        return firstChain.blocks[previousBlockIndex]
    }
    
    func append(layerToScrollView layer: CAShapeLayer) {
        scrollView.layer.addSublayer(layer)
    }
    
    // It was easier to erase state (color) of all blocks, then reapply
    // for every block valid colors
    func colorMiddleBlocks(fromIndex index: Int) {
        chains
            .map(\.blocks)
            .joined()
            .forEach { block in
                block.updateBackground(toColor: .orphanedBlockColor)
            }
        
        guard let middleChain = chains.first else { return }
        for blockIndex in 0...max(0, index) {
            middleChain.blocks[blockIndex].updateBackground(toColor: .defaultBlockColor)
        }
    }
    
    func append(byChain chain: ChainController, blockToScrollView block: BlockRepresentationView) {
        scrollView.addSubview(block)
        
        guard !chains.isEmpty && !block.isButton else { return }
        if block === mainChain.blocks.last {
            mainChain.colorOutBlocks(toColor: .defaultBlockColor)
            
        } else {
            recolorBlocksIfNeeded(forNewBlock: block, inChain: chain)
        }
        
        // Increase scrollView's content size and scroll if needed.
        if scrollView.frame.maxX - 100 <= block.frame.maxX + 200 {
            let increaseSize = block.frame.maxX + chain.blockVerticalSpacing * 2 + block.frame.width
            guard increaseSize > scrollView.contentSize.width else { return }
            scrollView.contentSize.width = increaseSize
            
            let offset = CGPoint(x: scrollView.contentSize.width - scrollView.bounds.size.width, y: 0)
            previousXOffset = offset.x
            scrollView.setContentOffset(offset, animated: true)
        }
    }
    
    func recolorBlocksIfNeeded(forNewBlock block: BlockRepresentationView, inChain chain: ChainController) {
        if block.index >= mainChain.distanceFromGenesis - 1 {
            setMainChain(to: chain)
            
            if scrollView.contentSize.width <= chain.appendButton?.frame.maxX ?? 0 {
                scrollView.contentSize.width += block.frame.width
            }
        }
    }
    
    func canPutAppendButton(onIndex index: Int, ofPosition positon: ChainPosition) -> Bool {
        chains
            .filter { $0.position == positon }
            .map(\.blocks)
            .joined()
            .first(where: { $0.index == index + 1 }) == nil
    }
}

// MARK: Overrides
fileprivate extension BlockchainViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
        addScrollView()
        configureMiddleChain()
        prepareNotifications()
    }
    
    func prepareNotifications() {
        registerNotification(withName: Constants.enableUpperButtonNotification) { (_) in
            self.enableButton(self.upperChainButton)
        }
        
        registerNotification(withName: Constants.enableBottomButtonNotification) { (_) in
            self.enableButton(self.bottomChainButton)
        }
        
        registerNotification(withName: Constants.disableUpperButtonNotification) { (_) in
            self.disableButton(self.upperChainButton)
        }
        
        registerNotification(withName: Constants.disableBottomButtonNotification) { (_) in
            self.disableButton(self.bottomChainButton)
        }
    }
        
    func registerNotification(withName name: Notification.Name, handler: @escaping (Notification) -> Void) {
        NotificationCenter.default.addObserver(
            forName: name,
            object: nil,
            queue: nil,
            using: handler)
    }
    
    func configureMiddleChain() {
        let middleChain = ChainController(presenter: self)
        setMainChain(to: middleChain)
        chains.append(middleChain)
    }
    
    func setMainChain(to chain: ChainController) {
        mainChain = chain
        colorMiddleBlocks(fromIndex: chain.absoluteStartIndex - 1)
        chain.colorOutBlocks(toColor: .defaultBlockColor)
    }
    
    func createNewChain(onPosition position: ChainPosition) -> ChainController {
        let chainIndex = chains.first!.numberOfBlocks
        let chain = ChainController(absoluteStartIndex: chainIndex, presenter: self, position: position)
        
        return chain
    }
    
    func append(chain: ChainController) {
        chains.append(chain)
        
        if chain.distanceFromGenesis >= mainChain.distanceFromGenesis {
            setMainChain(to: chain)
        }
    }
    
    func addNewChain(toPosition position: ChainPosition) {
        let chain = createNewChain(onPosition: position)
        append(chain: chain)
    }
}


// MARK: Base UI
fileprivate extension BlockchainViewController {
    func addScrollView() {
        view.addSubview(scrollView)
        scrollView.autoresizingMask = .flexibleRightMargin
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 20)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.subviews.first!.topAnchor)
        ])
    }
    
    func configureButtons() {
        upperChainButton = prepareButton(forPosition: .upper)
        bottomChainButton = prepareButton(forPosition: .bottom)
        
        let stackView = UIStackView(subviews: [upperChainButton, bottomChainButton])
        view.addSubview(stackView)
        stackView.pinToBottom(of: view)
    }
    
    func prepareButton(forPosition position: ChainPosition) -> UIButton {
        let action: UIAction = {
            switch position {
            case .upper: return leftButtonHandler()
            case .bottom: return rightButtonHandler()
            default: preconditionFailure("How did we get here?")
            }
        }()
        
        return UIButton(title: "Create a new \(position.rawValue) chain", action: action)
    }
    
    func disableButton(_ button: UIButton) {
        button.isEnabled = false
        button.backgroundColor = .systemGray
    }
    
    func enableButton(_ button: UIButton) {
        button.isEnabled = true
        button.backgroundColor = .systemBlue
    }
}

// MARK: Handlers
fileprivate extension BlockchainViewController {
    func leftButtonHandler() -> UIAction {
        UIAction { action in
            self.addNewChain(toPosition: .upper)
            let button = (action.sender as! UIButton)
            self.disableButton(button)
        }
    }
    
    func rightButtonHandler() -> UIAction {
        UIAction { action in
            self.addNewChain(toPosition: .bottom)
            let button = (action.sender as! UIButton)
            self.disableButton(button)
        }
    }
}



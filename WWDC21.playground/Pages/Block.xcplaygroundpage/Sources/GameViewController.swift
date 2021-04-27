import UIKit
import SwiftUI

public class GameViewController: UIHostingController<GameView> {
    public init(numberOfBlocks: Int) {
        let gameViewModel = GameViewModel(numberOfBlocks: numberOfBlocks)
        super.init(rootView: GameView(viewModel: gameViewModel))
    }
    
    override public init?(coder aDecoder: NSCoder, rootView: GameView) {
        super.init(coder: aDecoder, rootView: GameView())
    }
    
    @objc required dynamic public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: GameView())
    }
}

import SwiftUI

public struct GameView: View {
    @StateObject var viewModel: GameViewModel
    @State private var position = 0
    @State private var presentModal = false
    
    public var body: some View {
        VStack {
            TabView(selection: $position) {
                ForEach(viewModel.blocksData, id: \.blockHash) { block in
                        BlockView(block: block)
                            .tag(block.index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .alert(isPresented: $presentModal, content: alert)
            
            HashCalculationButton(acquiredHash: viewModel.blocksData[position].blockHash)
                .padding([.bottom, .top])
            DecisionControlsView(block: viewModel.blocksData[position],
                                 validButtonWasPressedHandler: validButtonWasPressed,
                                 invalidButtonWasPressedHandler: invalidButtonWasPressed)
        }
        .padding([.bottom], 50)
    }
    
    private var alert: Alert {
        if viewModel.blocksData.count - 1 == position {
            return validBlockAlert
        } else {
            return invalidBlockAlert
        }
    }
    
    private var invalidBlockAlert: Alert {
        Alert(title: Text(viewModel.modalTitle!),
              message: Text(viewModel.modalDescription!),
              primaryButton: .default(Text("Go to the beginning"), 
                                      action: restartGameState),
              secondaryButton: .default(Text("Check rest of the blocks"),
                                        action: pushForwardInvalidBlock))
    }
    
    private var validBlockAlert: Alert {
        Alert(title: Text(viewModel.modalTitle!),
              message: Text(viewModel.modalDescription!),
              dismissButton: .default(Text("Go to the beginning"),
                                      action: restartGameState))
    }
    
    init(viewModel: GameViewModel = GameViewModel(numberOfBlocks: 7)) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private func validButtonWasPressed(withBlock block: BlockData) {
        switch block.invalidationReason {
        case nil: pushForward()
        default: presentLoseModal(withBlock: block)
        }
    }
    
    private func invalidButtonWasPressed(withBlock block: BlockData) {
        switch block.invalidationReason {
        case nil: presentLoseModal(withBlock: block)
        default: presentWinModal(didFindInvalidBlock: true)
        }
    }
    
    private func pushForward(isBlockValid: Bool = true) {
        if position == viewModel.blocksData.count - 1 || !isBlockValid {
            presentWinModal(didFindInvalidBlock: !isBlockValid)
        } else {
            withAnimation { position += 1 }
        }
    }
    
    private func presentLoseModal(withBlock block: BlockData) {
        let previousBlockHash = viewModel.hashOfBlock(atIndex: block.index - 1)
        var textType: ModalTextType!
        
        switch block.invalidationReason {
        case .wrongHash:
            textType = .loseByWrongHash(
                presentedHash: block.wrongBlockHash ?? "None",
                validHash: block.blockHash)
            
        case .wrongPreviousBlockHash:
            textType = .loseByWrongPreviousHash(
                presentedHash: block.previousBlockHash ?? "None",
                validHash: previousBlockHash ?? "None")
            
        case nil:
            textType = .loseEverythingIsValid
        }
        
        viewModel.setModalText(toType: textType)
        presentModal = true
    }
    
    private func presentWinModal(didFindInvalidBlock: Bool) {
        var textType: ModalTextType!
        
        switch (viewModel.continueAfterFindingInvalidBlock, didFindInvalidBlock) {
        case (false, true):
                textType = .wonByFindingInvalidBlock
        case (true, false):
            textType = .loseButWentToTheEnd
        case (true, true):
            fallthrough
        case (false, false):
            textType = .won
        }
        
        viewModel.setModalText(toType: textType)
        presentModal = true
    }
    
    private func restartGameState() {
        withAnimation { position = 0 }
        presentModal = false
        viewModel.continueAfterFindingInvalidBlock = false
        viewModel.setModalText(toType: nil)
    }
    
    private func pushForwardInvalidBlock() {
        viewModel.continueAfterFindingInvalidBlock = true
        pushForward()
    }
}

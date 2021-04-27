import SwiftUI

struct DecisionControlsView: View {
    let block: BlockData
    let validButtonWasPressedHandler: (BlockData) -> ()
    let invalidButtonWasPressedHandler: (BlockData) -> ()
    
    var body: some View {
        HStack {
            Button("Valid") { validButtonWasPressedHandler(block) }
                .frame(width: 100)
                .prettifyButton(with: .green)
            Button("Invalid") { invalidButtonWasPressedHandler(block) }
                .frame(width: 100)
                .prettifyButton(with: .red)
        }
    }
    
    init(block: BlockData,
                validButtonWasPressedHandler: @escaping (BlockData) -> (),
                invalidButtonWasPressedHandler: @escaping (BlockData) -> ()) {
        self.block = block
        self.validButtonWasPressedHandler = validButtonWasPressedHandler
        self.invalidButtonWasPressedHandler = invalidButtonWasPressedHandler
    }
}

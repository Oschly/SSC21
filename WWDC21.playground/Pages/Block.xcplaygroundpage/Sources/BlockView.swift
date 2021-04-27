import SwiftUI

/// Represents single block in blockchain game.
public struct BlockView: View {
    let block: BlockData
    var size: CGSize { UIScreen.main.bounds.size }
    
    public var body: some View {
        VStack {
            Group {
                Text("Hash:")
                Text(block.hashToPresent)
                    .font(Font.largeTitle.weight(.bold))
            }
            DataView(data: block.data)
            
            Text("Previous block hash:")
            Text(block.previousBlockHash ?? "None")
                .font(Font.largeTitle.weight(.bold))
                .padding(.bottom)
        }
        .font(.largeTitle)
        .frame(idealWidth: 700)
        .padding()
        .multilineTextAlignment(.center)
        .background(Color.orange)
        .cornerRadius(8)
    }
}

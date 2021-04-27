import SwiftUI

struct HashCalculationButton: View {
    @State private var opacity = 0.0
    let acquiredHash: String
    
    var body: some View {
        VStack {
            Button("Calculate Hash") {
                withAnimation {
                    opacity = 1
                }
            }
            .prettifyButton(with: .blue)
            
            Text(acquiredHash)
                .font(Font.largeTitle.weight(.bold))
                .opacity(opacity)
                .onChange(of: acquiredHash) { newValue in 
                    opacity = 0
                }
        }
    }
}

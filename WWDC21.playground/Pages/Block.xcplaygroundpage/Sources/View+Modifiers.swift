import SwiftUI

extension View {
    // I should make feedback about that feature 🤔
    func disableTabViewSwiping() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .highPriorityGesture(DragGesture())
    }
    
    // Aaand also that.
    func alert(isPresented: Binding<Bool>,
               content: @autoclosure () -> Alert
                ) -> some View {
        alert(isPresented: isPresented, content: content)
    }
    
    func prettifyButton(with backgroundColor: Color) -> some View {
        return self
            .padding()
            .foregroundColor(.white)
            .background(backgroundColor)
            .font(.title)
            .cornerRadius(12)
    }
}

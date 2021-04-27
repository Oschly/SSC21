import SwiftUI

/// Part of BlockView, resolves is provided is data or string, then shows
/// a proper view with its data representation.
struct DataView: View {
    let data: Any
    
    var body: some View {
        VStack {
            Text("Data")
                .padding(.top, 5)
                .font(.title)
            if let imageData = data as? Data,
               let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .border(Color.black)
                    .padding([.leading, .trailing, .bottom])
            } else {
                Text(data as! String)
                    .font(.title)
                    .padding([.top, .leading, .trailing])
                    .border(Color.black)
                    .frame(maxWidth: 400, alignment: .center)
                    .padding([.leading, .trailing, .bottom])
            }
        }
    }
}

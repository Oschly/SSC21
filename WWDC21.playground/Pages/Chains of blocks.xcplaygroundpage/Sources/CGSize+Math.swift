import CoreGraphics

extension CGSize {
    static func /=(lhs: CGSize, rhs: CGFloat) -> CGSize {
        let width = lhs.width / rhs
        let height = lhs.height / rhs
        
        return CGSize(width: width, height: height)
    }
}

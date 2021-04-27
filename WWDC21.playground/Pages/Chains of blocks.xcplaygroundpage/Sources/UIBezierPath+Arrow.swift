import UIKit

extension UIBezierPath {
    // https://gist.github.com/mayoff/4146780
    // Please don't tell my math teacher that I had to find that in web
    static func arrow(from start: CGPoint, to end: CGPoint) -> Self {
        let tailWidth: CGFloat = 6
        let headWidth: CGFloat = 30
        let headLength: CGFloat = 15
        
        let length = hypot(
            end.x - start.x,
            end.y - start.y)
        let tailLength = length - headLength

        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x, y: y) }
        let points: [CGPoint] = [
            p(0, tailWidth / 2),
            p(tailLength, tailWidth / 2),
            p(tailLength, headWidth / 2),
            p(length, 0),
            p(tailLength, -headWidth / 2),
            p(tailLength, -tailWidth / 2),
            p(0, -tailWidth / 2)
        ]

        let cosine = (end.x - start.x) / length
        let sine = (end.y - start.y) / length
        let transform = CGAffineTransform(
            a: cosine,
            b: sine,
            c: -sine,
            d: cosine,
            tx: start.x,
            ty: start.y)

        let path = CGMutablePath()
        path.addLines(
            between: points,
            transform: transform)
        path.closeSubpath()

        return .init(cgPath: path)
    }
}

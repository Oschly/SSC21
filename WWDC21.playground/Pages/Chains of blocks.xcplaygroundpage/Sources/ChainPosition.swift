import Foundation

enum ChainPosition: String, CaseIterable {
    case upper
    case middle
    case bottom
    
    static var random: ChainPosition {
        allCases.randomElement()!
    }
}

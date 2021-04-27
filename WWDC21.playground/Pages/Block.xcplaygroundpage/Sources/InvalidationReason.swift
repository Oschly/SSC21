import Foundation

public enum InvalidationReason: CaseIterable {
    case wrongHash
    case wrongPreviousBlockHash
}

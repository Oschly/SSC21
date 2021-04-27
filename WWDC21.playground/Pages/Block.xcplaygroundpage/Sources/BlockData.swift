import Foundation

struct BlockData: Hashable {
    var id: String { blockHash }
    let invalidationReason: InvalidationReason?
    let index: Int
    let blockHash: String
    let previousBlockHash: String?
    var wrongBlockHash: String?
    let data: Any // either string or image data
    
    // In block show wrong hash if exists, `calculateHash()` will always
    // return a valid value.
    var hashToPresent: String {
        if let wrongBlockHash = wrongBlockHash {
            return wrongBlockHash
        }
        return blockHash
    }
    
    public static func == (lhs: BlockData, rhs: BlockData) -> Bool {
        lhs.blockHash == rhs.blockHash
    }
    
    public func hash(into hasher: inout Hasher) {
        // The only object that says if block is unique.
        hasher.combine(blockHash)
    }
    
    func calculateHash() -> String {
        blockHash
    }
}

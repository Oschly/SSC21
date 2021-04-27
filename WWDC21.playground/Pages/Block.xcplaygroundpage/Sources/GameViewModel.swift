import SwiftUI

final class GameViewModel: ObservableObject {
    var blocksData: [BlockData] = []
    var lastBlockHash: String? { blocksData.last?.blockHash }
    
    var modalTitle: String? = nil
    var modalDescription: String? = nil
    
    let numberOfBlocks: Int
    var lastUsedMeme: Int? = nil
    
    @Published var continueAfterFindingInvalidBlock = false
    
    init(numberOfBlocks: Int) {
        self.numberOfBlocks = numberOfBlocks
        generateNewData()
    }
    
    func setModalText(toType textType: ModalTextType?) {
        if let textType = textType {
            let strings = textType.modalStrings
            modalTitle = strings.modalTitle
            modalDescription = strings.modalDescription
        } else {
            modalTitle = nil
            modalDescription = nil
        }
    }
    
    private func generateNewData() {
        blocksData.removeAll(keepingCapacity: true)
        objectWillChange.send()
        let shouldChainBeValid = Bool.random()
        let randomIndex = Int.random(in: 1..<numberOfBlocks)
        
        for blockIndex in 0..<numberOfBlocks {
            if blockIndex == randomIndex && !shouldChainBeValid {
                let invalidationReason = InvalidationReason.allCases.randomElement()!
                blocksData.append(makeBlock(
                                    withInvalidationReason: invalidationReason,
                                    index: blockIndex))
            } else {
                blocksData.append(makeBlock(
                                    withInvalidationReason: nil,
                                    index: blockIndex))
            }
        }
        
        objectWillChange.send()
    }
    
    func hashOfBlock(atIndex index: Int) -> String? {
        blocksData
            .first(where: { $0.index == index })?
            .blockHash
    }
    
    func generateMeme() -> Any {
        let lastUsedMember = [lastUsedMeme].compactMap { num in num }
        let randomId = Set<Int>(0...12)
            .subtracting(Set(lastUsedMember))
            .randomElement()!
        defer { lastUsedMeme = randomId }
        
        let isImage = randomId > 2
        let fileExtension = isImage ? "png" : "txt"
        guard let url = Bundle.main.url(forResource: "\(randomId)", withExtension: fileExtension) else { preconditionFailure() }
        
        if isImage {
            return try! Data(contentsOf: url)
        }
        
        return try! String(contentsOf: url)
    }
    
    func makeBlock(withInvalidationReason invalidationReason: InvalidationReason?, index: Int) -> BlockData {
        let hashLength = Int.random(in: 7...10)
        let data = generateMeme()
        let hash = String.random(length: hashLength)
        
        var previousBlockHash: String!
        var wrongBlockHash: String? = nil
        
        previousBlockHash = lastBlockHash
        if invalidationReason == .wrongPreviousBlockHash {
            previousBlockHash = createWrongHash(validHash: lastBlockHash ?? "")
        } else if invalidationReason == .wrongHash {
            wrongBlockHash = createWrongHash(validHash: hash)
        }
        
        return BlockData(
            invalidationReason: invalidationReason,
            index: index,
            blockHash: hash,
            previousBlockHash: previousBlockHash,
            wrongBlockHash: wrongBlockHash,
            data: data)
    }
    
    private func createWrongHash(validHash: String) -> String {
        // Let leave user's fate in computer's hands.
        let shouldBeHardToResolve = Bool.random()
        
        if shouldBeHardToResolve && !validHash.isEmpty {
            return validHash.swapRandomLetters()
        } else {
            return .random(length: Int.random(in: 7...10))
        }
    }
}

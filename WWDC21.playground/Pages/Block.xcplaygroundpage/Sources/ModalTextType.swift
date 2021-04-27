enum ModalTextType {
    case won
    case wonByFindingInvalidBlock
    case loseEverythingIsValid
    case loseByWrongHash(presentedHash: String, validHash: String)
    case loseByWrongPreviousHash(presentedHash: String, validHash: String)
    case loseButWentToTheEnd
    
    var modalStrings: ModalStrings {
        switch self {
        case .won:
            return ModalStrings(
                modalTitle: "You've validated the chain!",
                modalDescription: """
Yay! Data is not corrupted!
To try with a new chain, run again code on this page.
""")
            
        case .wonByFindingInvalidBlock:
            return ModalStrings(
                modalTitle: "You've found invalid block!",
                modalDescription: """
                Congratulations! You have saved other users and yourself from corrupted data!
                To try with a new chain, run again code on this page.
                """)
            
        case .loseEverythingIsValid:
            return ModalStrings(
                modalTitle: "You lose!",
                modalDescription: "This block is fine.")
            
        case .loseByWrongHash(let presentedHash, let validHash):
            return ModalStrings(
                modalTitle: "You lose!",
                modalDescription: """
                Hashes don't match:
                Presented hash: \(presentedHash)
                Valid Hash: \(validHash)

                To try with a new chain, run again code on this page.
                """)
            
        case .loseByWrongPreviousHash(let presentedHash, let validHash):
            return ModalStrings(
                modalTitle: "You lose!",
                modalDescription: """
Hash of previous block doesn't match with a real one!
Presented previous hash: \(presentedHash)
Hash of the last block: \(validHash)

To try with a new chain, run again code on this page.
""")
            
            case .loseButWentToTheEnd:
                return ModalStrings(
                    modalTitle: "That's all!", 
                    modalDescription: "If You would like to play again, recompile the page."
                )
        }
    }
}

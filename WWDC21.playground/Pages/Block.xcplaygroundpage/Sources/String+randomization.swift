import Foundation

public extension String {
    // https://stackoverflow.com/a/26845710/8140676
    static func random(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString = String(
            (0..<length)
                .map { _ in letters.randomElement()! }
        )
        
        return randomString
    }
    
    func swapRandomLetters() -> String {
        // How many swaps maximally should perform
        let swapsNumber = Int.random(in: 1..<(count / 2))
        var swapped = 0
        var newString = ""
        
        for letter in self {
            // If random and string isn't swapped enough
            if Bool.random() && swapped < swapsNumber {
                let randomChar = String.random(length: 1)
                newString.append(randomChar)
                swapped += 1
            } else {
                newString.append(letter)
            }
        }
        
        // If swapping didn't success (Bool.random() returned false in all cases
        // do the calculation again
        guard swapped > 0 else { return newString.swapRandomLetters() }
        return newString
    }
}

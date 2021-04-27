//: [I forgot what's blockchain at all](Chains%20of%20blocks)
/*:
 # So, what is the block in blockchain?
 It's just a representation of data.
 Usually, it contains three basic parts:
 1. Reference to the previous block (usually its hash).
 It's one of the most basic verification of data integrity. When reference points to nothing (block doesn't exist or changed its structure by some bad person, so hash has changed) the whole blockchain becomes invalid. This proves that the data that the blockchain contains non-modified data.
 
 2. Data.
 This is the part which the end-user cares most about. Here is stored data that we want to keep in the blockchain. Usually this part is used to calculate block's hash. It can be simple text, but it can be also a huge file (10GB and more), but people that are implementing it have to keep in mind that it can drastically reduce the performance of blockchain if data stored in single block is huge.
 
 3. Hash.
 The most important part for the security of the basic blockchain. To calculate it, we usually use only the data from a point above. To check if the block is valid, computers read the hash provided from the sender of that blockchain and calculate the other one on their own. If hashes are equal, the block is validated, but when they aren't, we shouldn't trust the data that is contained in this fork (chain that contains older part of other chain and is building now own, different blocks than the chain that it borrowed previous ones from) and especially in the corrupted block.
 
 Now let's play a game. You are going to see blocks in a single chain. Your mission is to check if all blocks are valid. Your results will be compared with "network's" chain validation, so you will know if you're right.
 
 You can also choose the number of blocks that you would like to validate, but be careful, there is a limited amount of "content" that I was able to provide to this submission, so if you don't want to "kill" the fun too early, enter a small value.
 
 If You would like to validate another chain, just recompile the code below.
 
 Tip: There's no option to go back check previous chains (only when you lose you can go to the beginning), so it's good to note hashes of the blocks :)
 
 Good luck!
 */
//#-hidden-code
var numberOfBlocks = 7
//#-end-hidden-code
numberOfBlocks = /*#-editable-code*/4/*#-end-editable-code*/
//#-hidden-code
import PlaygroundSupport
let blockGameViewController = GameViewController(numberOfBlocks: numberOfBlocks)
PlaygroundPage.current.liveView = blockGameViewController
//#-end-hidden-code

//: [Where is it used?](Usage%20examples)

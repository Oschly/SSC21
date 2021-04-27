//: [Start](@previous)
/*:
 # Blockchain is "just" a block of chains
 and it's important to know a few things about it:
 - first block in a blockchain is called *genesis* block.
 - main chain is the longest and contains the newest changes.
 - all other chains are called *orphaned* chains.
 
 When you run this page, you will see a simple blockchain that allows you to manage a multiple chains in 3 columns and see how are they updated when changes are made.
 
 Colors:
 - green is for genesis block,
 - gray represents orphaned chains,
 - red is for blocks in the chain.
 
 */
//#-hidden-code
//#-editable-code

//#-end-editable-code
import PlaygroundSupport
let blockChainViewController = BlockchainViewController()
PlaygroundPage.current.liveView = blockChainViewController
//#-end-hidden-code

//: [What's a block?](Block)

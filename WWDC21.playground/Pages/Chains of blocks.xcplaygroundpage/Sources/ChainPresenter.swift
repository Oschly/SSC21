import UIKit

protocol ChainPresenter {
    var frame: CGRect { get }
    var mainChain: ChainController! { get set }
    
    func blockBehind(index: Int) -> BlockRepresentationView
    func colorMiddleBlocks(fromIndex index: Int)
    func append(byChain chain: ChainController, blockToScrollView block: BlockRepresentationView)
    func append(layerToScrollView layer: CAShapeLayer)
    func canPutAppendButton(onIndex index: Int, ofPosition positon: ChainPosition) -> Bool
}

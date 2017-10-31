//
//  TetrisBlock.swift
//  TetrisStarter
//
//  Created by AAK on 9/26/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class TetrisBlockView: UIView {

    let blockColor: UIColor
    let blockModel: TetrisBlockModel
    let blockSize: Int
    var animator: UIViewPropertyAnimator!
    var angle = CGFloat(0.0)
    var blockBounds: CGSize
    var boardModel: TetrisBoardModel
    var prevPosition: CGPoint
    let distancePerSec: CGFloat = 80
    
    init(grid: TetrisBlockModel, y: CGFloat, x: CGFloat) {
        blockColor = grid.getColor()
        blockModel = grid
        boardModel = grid.getBoard()
        self.blockSize = Int(grid.getBoard().getBlockSize())
        let width = CGFloat(blockSize * grid.blocksWide())
        let height = CGFloat(blockSize * grid.blocksHigh())
        blockBounds = CGSize(width: width, height: height)
        let frame = CGRect(x: x, y: y, width: width, height: height)
        prevPosition = CGPoint(x: 0, y: 0)
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        snapToGrid(SnapToX: true, SnapToY: true)
        addSubBlocksToView(grid: grid, blockSize: blockSize)
    }

    func startDescent() {
        self.startNewFallAnimation(DistancePerSec: distancePerSec)
        animator.startAnimation()
        //blockModel.printEdges()
    }
    
    func moveToPosition(x: Int, y: Int) {
        self.center.x = CGFloat(x)
        self.center.y = CGFloat(y)
        snapToGrid(SnapToX: true, SnapToY: true)
    }
    
    func moveToTopCenter(){
        print("moving to center. previous location was \(self.center.x), \(self.center.y)")
        self.center.x = self.boardModel.frame.midX
        self.center.y = self.boardModel.frame.minY + CGFloat(self.blockModel.blocksHigh() * self.blockSize) / 2
        print("new center is \(self.center.x), \(self.center.y)")
        snapToGrid(SnapToX: true, SnapToY: true)
    }
        
    func snapToGrid(SnapToX: Bool, SnapToY: Bool){
        var x = (((self.center.x)/CGFloat(blockSize)).rounded() * CGFloat(blockSize))
        var y = (((self.center.y)/CGFloat(blockSize)).rounded() * CGFloat(blockSize))
        if blockModel.blocksWide() % 2 != 0 {  // pieces with odd number of sub-blocks will be shifted by blockSize/2 so they start on grid lines.
            x -= CGFloat(blockSize) / CGFloat(2.0)
        }
        if blockModel.blocksHigh() % 2 != 0 {
            y -= CGFloat(blockSize) / CGFloat(2.0)
        }
        self.center.x = x
        self.center.y = y
    }
    
    func pauseAnimation() {
        if animator.state == .active {
            animator.pauseAnimation()
        }
    }
    
    func startAnimation() {
        if animator.state == .active {
            animator.startAnimation()
        }
    }
    
    func startNewFallAnimation(DistancePerSec: CGFloat){
        if animator != nil{
            animator.stopAnimation(true)}
        prevPosition = self.center
        let fallDistance = self.boardModel.getFallDistance(blockModel: self.blockModel, center: self.center)
        animator = UIViewPropertyAnimator(duration: Double(fallDistance/DistancePerSec), curve: .linear) { [unowned self] in
            self.center.y += fallDistance
        }
        animator.addCompletion { position in
            switch position {
            case .end:
                //print("completion handler called at the end of the animation")
                print("pre completion wait")
                usleep(useconds_t(1000000.0 * CGFloat(self.blockSize) / 2.0 / self.distancePerSec))
                print("wait done")
                self.boardModel.attachBlockToBoard(blockModel: self.blockModel, center: self.center)
                NotificationCenter.default.post(name: Constants.BLOCK_LAND_NOTIFY, object: nil)
            case .current:
                print("completion handler called mid animation")
            case .start:
                print("completion handler called at the start of the animation")
            }
        }
    }
    
    func moveSideWays(offset: Int) {
        if animator.state == .active {
            animator.pauseAnimation()
            let currentY = self.prevPosition.y + animator.fractionComplete * (self.center.y - self.prevPosition.y)
            let x = self.center.x + CGFloat(offset)
            if boardModel.collides(blockModel: self.blockModel, center: CGPoint(x: x, y: currentY)){
                self.animator.startAnimation()
                return
            }
            UIView.animate(withDuration: 0.3, animations: { [unowned self, x] in
                self.center.x = x
                }, completion: { [unowned self] (_) in
                    self.startDescent()
                    //self.animator.startAnimation()
            })
        }
    }
    
    func printEdgeValues(edge: Edges) {
        let bottom = blockModel.edgeAttributes(edge: edge)
        print(bottom.direction)
        print(bottom.edgeOffsets())
    }
    
    func moveRight() {
        moveSideWays(offset: blockSize)
    }
    
    func moveLeft() {
        moveSideWays(offset: -blockSize)
    }
    
    func rotateBlock(rotationAngle: CGFloat) -> Bool {
        
        
        animator.pauseAnimation()
        //let aPoint = CGPoint(x: 0.0, y: 0.0)  // upper-left
        //let aPointInSuperView = superview!.convert(aPoint, from: self)
        //print("Choosing reference point \(aPoint) to calculate the x-offset after the rotation.")
        //print("The above reference point translated into the superview (board) is \(aPointInSuperView)")

        // Set up a new animation for the purpose of rotating the block.
        angle += rotationAngle
        
        var x = (((self.center.x)/CGFloat(self.blockSize)).rounded() * CGFloat(self.blockSize))
        if self.blockModel.blocksWide() % 2 != 0 {  // pieces with odd number of sub-blocks will be shifted by blockSize/2 so they start on grid lines.
            x -= CGFloat(self.blockSize) / CGFloat(2.0)
        }
        let currentY = self.prevPosition.y + animator.fractionComplete * (self.center.y - self.prevPosition.y)
        if boardModel.collides(blockModel: self.blockModel, center: CGPoint(x: x, y: currentY)){
            self.animator.startAnimation()
            return false
        }
        
        let rotation = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) { [unowned self, angle] in
            self.transform = CGAffineTransform(rotationAngle: angle)

            self.center.x = x//CGPoint(x: self.center.x - CGFloat(diffX), y: self.center.y)
        }
        rotation.addCompletion({ [unowned self] (_) in
            //self.animator.startAnimation()
            self.startDescent()
        });
        
        // Once the rotation is complete, we will have to make sure that the block is aligned on the edge
        // of some vertical gridline. The gridlines are blockSize apart and logically divide the board.
        rotation.startAnimation()
        return true
    }
    
    func rotateCounterClockwise() {
        if animator.state != .active {
            return
        }
        animator.pauseAnimation()
        blockModel.didRotateCounterClockwise()
        if !rotateBlock(rotationAngle: -CGFloat.pi / 2.0){
            blockModel.didRotateClockwise()
        }
        
        //printEdgeValues(edge: Edges.bottom)
        animator.startAnimation()
    }
    
    func rotateClockWise() {
        if animator.state != .active {
            return
        }
        animator.pauseAnimation()
        blockModel.didRotateClockwise()
        if !rotateBlock(rotationAngle: CGFloat.pi / 2.0) {
            blockModel.didRotateCounterClockwise()
        }
        
        //printEdgeValues(edge: Edges.bottom)
        animator.startAnimation()
    }
    
    func fastDown(){
        self.startNewFallAnimation(DistancePerSec: distancePerSec * 4)
        print("sending down at 4x speed")
        animator.startAnimation()
    }
    
    func addSubBlocksToView(grid: TetrisBlockModel, blockSize: Int) {
        var topLeftY = 0
        for row in 0 ..< grid.blocksHigh() {
            var topLeftX = 0
            for column in 0 ..< grid.blocksWide() {
                let bView = UIView(frame: CGRect(x: topLeftX, y: topLeftY, width: blockSize, height: blockSize))
                addSubview(bView)

                if grid.hasBlockAt(row: row, column: column) {
                    bView.backgroundColor = blockColor
                } else {
                    bView.backgroundColor = UIColor.clear 
                }
                topLeftX += blockSize
            }
            topLeftY += blockSize
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

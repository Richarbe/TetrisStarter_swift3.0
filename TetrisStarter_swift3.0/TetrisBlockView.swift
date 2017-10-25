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
    
    init(color: UIColor, grid: TetrisBlockModel, blockSize: Int, startY: CGFloat, boardCenterX: CGFloat) {
        blockColor = color
        blockModel = grid
        self.blockSize = blockSize
        let width = CGFloat(blockSize * grid.blocksWide())
        let height = CGFloat(blockSize * grid.blocksHigh())
        blockBounds = CGSize(width: width, height: height)
        var x = (boardCenterX/CGFloat(blockSize)).rounded() * CGFloat(blockSize)
        var y = (startY/CGFloat(blockSize)).rounded() * CGFloat(blockSize) //Partially done
        var testwide = grid.blocksWide()
        var testhigh = grid.blocksHigh()
        if grid.blocksWide() % 2 == 1 {  // pieces with odd number of sub-blocks will be shifted by blockSize/2 so they start on grid lines.
            x -= CGFloat(blockSize) / CGFloat(2.0)
        }
        if grid.blocksHigh() % 2 == 1 {
            y -= CGFloat(blockSize) / CGFloat(2.0)
        }
        
        let toTravel = CGFloat(blockSize * 12)
        let frame = CGRect(x: x, y: y, width: width, height: height)
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubBlocksToView(grid: grid, blockSize: blockSize)
        animator = UIViewPropertyAnimator(duration: 5.0, curve: .linear) { [unowned self] in
            self.center.y += toTravel
        }
    }

    func startDescent() {
        animator.startAnimation()
        blockModel.printEdges()
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
    
    func moveSideWays(offset: Int) {
        if animator.state == .active {
            animator.pauseAnimation()
            UIView.animate(withDuration: 0.8, animations: { [unowned self, offset] in
                self.center.x = self.center.x + CGFloat(offset)
                }, completion: { [unowned self] (_) in
                    self.animator.startAnimation()
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
    
    func rotateBlock(rotationAngle: CGFloat) {
        animator.pauseAnimation()
        
        let aPoint = CGPoint(x: 0.0, y: 0.0)  // upper-left
        let aPointInSuperView = superview!.convert(aPoint, from: self)
        print("Choosing reference point \(aPoint) to calculate the x-offset after the rotation.")
        print("The above reference point translated into the superview (board) is \(aPointInSuperView)")

        // Set up a new animation for the purpose of rotating the block.
        angle += rotationAngle
        let rotation = UIViewPropertyAnimator(duration: 1.0, curve: .easeInOut) { [unowned self, angle] in
            self.transform = CGAffineTransform(rotationAngle: angle)
        }
        
        // Once the rotation is complete, we will have to make sure that the block is aligned on the edge
        // of some vertical gridline. The gridlines are blockSize apart and logically divide the board.
        rotation.addCompletion { [unowned self] (_) in
            let aPointTranslated = self.superview!.convert(aPoint, from: self)
            print("After rotation, we translate \(aPointInSuperView) in the superview to get \(aPointTranslated).")
            let diffX = Int(abs(aPointInSuperView.x - aPointTranslated.x)) % self.blockSize
            print("We are \(diffX) points off from a vertical gridline.")
            UIView.animate(withDuration: 0.5, animations: {
                self.center = CGPoint(x: self.center.x - CGFloat(diffX), y: self.center.y)
            })
            
            self.animator.startAnimation()
        }
        rotation.startAnimation()

    }
    
    func rotateCounterClockwise() {
        if animator.state != .active {
            return
        }
        animator.pauseAnimation()
        rotateBlock(rotationAngle: -CGFloat.pi / 2.0)
        blockModel.didRotateCounterClockwise()
        printEdgeValues(edge: Edges.bottom)
        animator.startAnimation()
    }
    
    func rotateClockWise() {
        if animator.state != .active {
            return
        }
        animator.pauseAnimation()
        rotateBlock(rotationAngle: CGFloat.pi / 2.0)
        blockModel.didRotateClockwise()
        printEdgeValues(edge: Edges.bottom)
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

//
//  TetrisBoardModel.swift
//  TetrisStarter_swift3.0
//
//  Created by student on 10/25/17.
//  Copyright © 2017 Ali A. Kooshesh. All rights reserved.
//

import UIKit

class TetrisBoardModel: NSObject {
    var frame: CGRect!
    var numRows: Int!
    var numColumns: Int!
    var occupied: [[Bool]]
    var blockSize: CGFloat!
    
    init(frame: CGRect, numRows: Int, numColumns: Int){
        
        self.frame = frame
        self.numRows = numRows
        self.numColumns = numColumns
        self.blockSize = (frame.width / CGFloat(numColumns)).rounded()
        self.occupied = [[]]
        super.init()
        self.occupied = genStartOccupiedMatrix()
    }
    
    func getBlockSize() -> CGFloat {
        return blockSize
    }
    
    func genStartOccupiedMatrix() -> [[Bool]] {
        var matrix:[[Bool]] = []
        for _ in 0..<numRows{
            var temp: [Bool] = [true]
            temp += [Bool](repeating: false, count: numColumns)
            temp.append(true)
            matrix.append(temp)
        }
        matrix.append([Bool](repeating: true, count: numColumns + 2))
        return matrix
    }
    
    func collides(blockModel: TetrisBlockModel, centerX: CGFloat, centerY: CGFloat) -> Bool{
        //Move x and y value to corner of tetris block, and shift right to allow for left wall
        let cornerX = Int(((centerX - (CGFloat(blockModel.blocksWide()) * blockSize / 2.0)) / blockSize).rounded()) + 1
        let cornerY = Int(((centerY - (CGFloat(blockModel.blocksHigh()) * blockSize / 2.0)) / blockSize).rounded())
        //print("testing collision. corner is at: \(cornerX), \(cornerY)")
        var blockVal: Bool
        for i in 0..<blockModel.blocksHigh(){
            for j in 0..<blockModel.blocksWide(){
                blockVal = blockModel.valueAt(row: i, col: j)
                //print("block's value at (row: \(i), col: \(j)) is \(blockVal)")
                if blockVal && occupied[cornerY+i][cornerX+j]{
                    return true
                }
            }
        }
        return false
    }
    
    
}

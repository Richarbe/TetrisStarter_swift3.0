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
    //var heightmap: [Int]
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
    
    func collides(blockModel: TetrisBlockModel, center: CGPoint) -> Bool{
        //Move x and y value to corner of tetris block, and shift right to allow for left wall
        let cornerX = Int(((center.x - (CGFloat(blockModel.blocksWide()) * blockSize / 2.0)) / blockSize).rounded())
        let cornerY = Int(((center.y - (CGFloat(blockModel.blocksHigh()) * blockSize / 2.0)) / blockSize).rounded())
        //print("testing collision. corner is at: \(cornerX), \(cornerY)")
        for i in 0..<blockModel.blocksHigh(){
            for j in 0..<blockModel.blocksWide(){
                //print("block's value at (row: \(i), col: \(j)) is \(blockVal)")
                if blockModel.valueAt(row: i, col: j) && occupied[cornerY+i][cornerX+1+j]{
                    return true //collision has happened
                }
            }
        }
        return false
    }
    
    func attachBlockToBoard(blockModel: TetrisBlockModel, center: CGPoint) {
        let cornerX = Int(((center.x - (CGFloat(blockModel.blocksWide()) * blockSize / 2.0)) / blockSize).rounded())
        let cornerY = Int(((center.y - (CGFloat(blockModel.blocksHigh()) * blockSize / 2.0)) / blockSize).rounded())
        for i in 0..<blockModel.blocksHigh(){
            for j in 0..<blockModel.blocksWide(){
                if blockModel.valueAt(row: i, col: j){
                    occupied[cornerY+i][cornerX+1+j] = true
                }
            }
        }
        /*
        for i in (cornerX)..<(cornerX + blockModel.blocksWide()){
            recalculateHeight(column: i)
        }*/
    }
    
    /*
    func recalculateHeight(column: Int){
        for i in 0..<numRows{
            if occupied[i][column+1]{
                heightmap[column] = numRows - i
                return
            }
        }
    }
    */
    private func getStopRow(startRow: Int, startColumn: Int) -> Int{
        for i in startRow..<numRows+1{
            if occupied[i][startColumn]{
                return i-1
            }
        }
        print("A block has fallen out of this world")
        return numRows
    }
    
    func getFallDistance(blockModel:TetrisBlockModel, center:CGPoint) -> CGFloat{
        var minStopRow: Int = numRows
        var stopRow: Int
        let cornerX = Int(((center.x - (CGFloat(blockModel.blocksWide()) * blockSize / 2.0)) / blockSize).rounded())
        let cornerY = Int(((center.y - (CGFloat(blockModel.blocksHigh()) * blockSize / 2.0)) / blockSize).rounded())
        for i in 0..<blockModel.blocksWide(){
            stopRow = getStopRow(startRow: cornerY + blockModel.blocksHigh() - blockModel.edgeAttributes(edge: .bottom).offsets[i],
                                 startColumn: cornerX + i + 1)
            if stopRow < minStopRow{
                minStopRow = stopRow
            }
        }
        let StopBottom = CGFloat(minStopRow+1) * blockSize
        let CurrentBottom = (center.y + CGFloat(blockModel.blocksHigh()) * blockSize / 2)
        let fallDistance = StopBottom - CurrentBottom
        return fallDistance
    }
    
    
}

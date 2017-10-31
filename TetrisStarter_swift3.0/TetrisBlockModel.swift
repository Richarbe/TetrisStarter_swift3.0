//
//  TetrisGrid.swift
//  TetrisStarter
//
//  Created by AAK on 9/26/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit


enum OffsetTraversal {
    case forward
    case backward
}

class TetrisBlockModel: NSObject {
    private let grid: [[Bool]]  // Every row is expected to have the same number of columns
    private var blockEdgeAttributes: GridEdgeAttributes!
    private var blockEdges = [TetrisBlockEdge]()
    private let edges: [Edges] = [.bottom, .left, .top, .right]  // Any order will work
    private var bottomEdgeIdx = 0
    private var currentDirection: OffsetTraversal
    private var board: TetrisBoardModel
    private var color: UIColor = UIColor.orange

    init(tetrisGrid: [[Bool]], tetrisBoardModel: TetrisBoardModel) {
        grid = tetrisGrid
        board = tetrisBoardModel
        currentDirection = .forward
        super.init()
        blockEdgeAttributes = GridEdgeAttributes(grid: grid)
        for edge in edges {
            blockEdges.append( blockEdgeAttributes.edgeAttributes(edgeName: edge)! )
        }
        
    }
    
    func valueAt(row: Int,col: Int) -> Bool{
        let maxRow = self.blocksHigh() - 1
        let maxCol = self.blocksWide() - 1
        switch bottomEdgeIdx{
        case 0:
            return grid[row][col]
        case 1: //one counterclockwise rotation, requires transpose and flip on y axis
            return grid[maxCol-col][row]
        case 2: //two counterclockwise rotations, requires flip on x and y axis.
            return grid[maxRow-row][maxCol-col]
        case 3: // three counterclockwise roations, requires transpose and flip on x axis
            return grid[col][maxRow-row]
        default:
            print("bottomEdgeIdx out of bounds, value is \(bottomEdgeIdx)")
            return false
        }
    }
    
    func printEdges() {
        for edge in edges {
            let edgeAttr = edgeAttributes(edge: edge)
            
            print(edgeAttr.edgeName, edgeAttr.direction)
            print(edgeAttr.edgeOffsets())
        }
    }
    
    func didRotateClockwise() {
        let lastIdx = blockEdges.count - 1
        
        //print("begin printing edges before rotating them cw")
        //printEdges()
        //print("end printing edges before rotating them cw")

        blockEdges = [blockEdges[lastIdx]] + blockEdges[0 ... lastIdx - 1]
        blockEdges[0].reverseOffsets()
        blockEdges[2].reverseOffsets()
        if bottomEdgeIdx == 0 { //swift lacks proper modulus, so I have to do it myself.
            bottomEdgeIdx = 3
        }else{
            bottomEdgeIdx = bottomEdgeIdx - 1
        }
        
        print("CWbottomEdgeIdx \(bottomEdgeIdx)")
        //print("begin printing edges after rotating them cw")
       // printEdges()
        //print("end printing edges after rotating them cw")
        

    }
    
    func didRotateCounterClockwise() {
        let lastIdx = blockEdges.count - 1
        //print("begin printing edges before rotating them ccw")
        //printEdges()
        //print("end printing edges before rotating them ccw")
        //print()
        blockEdges = blockEdges[1 ... lastIdx] + [blockEdges[0]]
        blockEdges[1].reverseOffsets()
        blockEdges[3].reverseOffsets()
        if bottomEdgeIdx == 3 { //swift lacks proper modulus, so I gotta do it myself.
            bottomEdgeIdx = 0
        }else{
            bottomEdgeIdx = bottomEdgeIdx + 1
        }
        print("CCWbottomEdgeIdx \(bottomEdgeIdx)")
        //print("begin printing edges after rotating them ccw")
        //printEdges()
        //print("end printing edges after rotating them ccw")
    }
    
    func edgeAttributes(edge: Edges) -> TetrisBlockEdge {
        var idx = 0
        switch edge {
        case Edges.bottom:
            idx = 0
        case Edges.left:
            idx = 1
        case Edges.top:
            idx = 2
        case Edges.right:
            idx = 3
        }
        blockEdges[idx].direction = currentDirection
        return blockEdges[idx]
    }
    
    func getColor() -> UIColor {
        return color
    }
    
    func setColor(color: UIColor){
        self.color = color
    }
    
    func getBoard() -> TetrisBoardModel {
        return board
    }
    
    func hasBlockAt(row: Int, column: Int) -> Bool {
        return grid[row][column]
    }
    
    func numRows() -> Int {
        return grid.count
    }
    
    func numColumns() -> Int {
        // pre-condition: every row has the same number of columns.
        return grid[0].count
    }
    
    func blocksWide() -> Int {
        if bottomEdgeIdx % 2 == 0{
            return numColumns()
        }else{
            return numRows()
        }
        
    }
    
    func blocksHigh() -> Int {
        if bottomEdgeIdx % 2 == 0{
            return numRows()
        }else{
            return numColumns()
        }
    }
    /*
    func smallestVisibleGrid() -> [[Bool]]? {
        return smallestSpanningGrid()
    }
    */
}

private extension TetrisBlockModel {
    func rowHasAVisibleBlock(row: Int) -> Bool {
        for column in 0 ..< numColumns() {
            if hasBlockAt(row: row, column: column) {
                return true
            }
        }
        return false
    }
    
    func columnHasAVisibleBlock(column: Int) -> Bool {
        for row in 0 ..< numRows() {
            if hasBlockAt(row: row, column: column) {
                return true
            }
        }
        return false
    }
    /*
    func smallestSpanningGrid() -> [[Bool]]? {
        // Finds the smallest two dimentional array that contains all
        // squares of the Tetris grid.
        var firstRow = 0
        while firstRow < numRows() && !rowHasAVisibleBlock(row: firstRow) {
            firstRow += 1
        }
        if firstRow == numRows() {
            return nil
        }
        var firstColumn = 0
        while firstColumn < numColumns() && !columnHasAVisibleBlock(column: firstColumn) {
            firstColumn += 1
        }
        if firstColumn == numColumns() {
            return nil
        }
        
        var lastVisibleRow = 0, lastVisibleColumn = 0
        for row in firstRow ..< numRows() {
            var didSeeAVisibleBlock = false
            for column in firstColumn ..< numColumns() {
                if hasBlockAt(row: row, column: column) && column > lastVisibleColumn {
                    lastVisibleColumn = column
                    didSeeAVisibleBlock = true
                }
            }
            if didSeeAVisibleBlock {
                lastVisibleRow = row
            }
        }
        let numVisibleRows = lastVisibleRow - firstRow + 1
        let numVisibleColumns = lastVisibleColumn - firstColumn + 1
        
        var visibleBlock = [[Bool]]()
        for row in 0 ..< numVisibleRows {
            var currentRow = [Bool]()
            for column in 0 ..< numVisibleColumns {
                currentRow.append( hasBlockAt(row: row + firstRow, column: column + firstColumn) )
            }
            visibleBlock.append(currentRow)
        }
        return visibleBlock
    }
     */

}

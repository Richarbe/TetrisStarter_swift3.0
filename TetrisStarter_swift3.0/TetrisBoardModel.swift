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
    
    init(frame: CGRect, numRows: Int, numColumns: Int){
        self.frame = frame
        self.numRows = numRows
        self.numColumns = numColumns
        super.init()
    }
    
    func getBlockSize() -> CGFloat {
        return (frame.width / CGFloat(numColumns))
    }
    
    func genStartOccupiedMatrix() -> [[Bool]] {
        return [[]]
    }
    
}

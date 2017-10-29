//
//  OTetrisGrid.swift
//  TetrisStarter
//
//  Created by Ben Richardson on 10/24/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class OTetrisGrid: TetrisBlockModel {
    
    let ogrid = [
        [true, true],
        [true, true]
    ]
    
    init(board: TetrisBoardModel) {
        super.init(tetrisGrid: ogrid, tetrisBoardModel: board)
        self.setColor(color: UIColor.blue)
    }
    
}


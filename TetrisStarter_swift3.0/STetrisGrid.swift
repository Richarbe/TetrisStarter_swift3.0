//
//  STetrisGrid.swift
//  TetrisStarter
//
//  Created by Ben Richardson on 10/24/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class STetrisGrid: TetrisBlockModel {
    
    let sgrid = [
        [false, true, true],
        [true, true, false]
    ]
    
    init(board: TetrisBoardModel) {
        super.init(tetrisGrid: sgrid, tetrisBoardModel: board)
        self.setColor(color: UIColor.purple)
    }
}


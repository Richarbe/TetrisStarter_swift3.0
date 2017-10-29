//
//  TTetrisGrid.swift
//  TetrisStarter
//
//  Created by Ben Richardson on 10/24/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class TTetrisGrid: TetrisBlockModel {
    
    let tgrid = [
        [false, true, false],
        [true, true, true]
    ]
    
    init(board: TetrisBoardModel) {
        super.init(tetrisGrid: tgrid, tetrisBoardModel: board)
        self.setColor(color: UIColor.green)
    }
    
}


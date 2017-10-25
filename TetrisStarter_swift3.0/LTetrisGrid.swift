//
//  LTetrisGrid.swift
//  TetrisStarter
//
//  Created by Ben Richardson on 10/24/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class LTetrisGrid: TetrisBlockModel {
    
    let lgrid = [
        [false, false, true],
        [true, true, true]
    ]
    
    init() {
        super.init(tetrisGrid: lgrid)
    }
    
}


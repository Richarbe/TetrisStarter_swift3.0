//
//  JTetrisGrid.swift
//  TetrisStarter
//
//  Created by AAK on 9/27/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class JTetrisBlock: TetrisBlockModel {

    let jgrid = [
        [true, false, false],
        [true, true, true]
    ]
    
    init() {
        super.init(tetrisGrid: jgrid)
    }

}

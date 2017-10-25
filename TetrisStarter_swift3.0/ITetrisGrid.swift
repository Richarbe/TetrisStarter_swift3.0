//
//  ITetrisGrid.swift
//  TetrisStarter
//
//  Created by Ben Richardson on 10/24/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class ITetrisGrid: TetrisBlockModel {
    
    let igrid = [
        [true, true, true, true]
    ]
    
    init() {
        super.init(tetrisGrid: igrid)
    }
    
}

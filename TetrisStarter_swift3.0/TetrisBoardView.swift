//
//  TetrisBoard.swift
//  TetrisStarter
//
//  Created by AAK on 9/30/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class TetrisBoardView: UIView {

    let gapBetweenCenters: CGFloat
    let markerRadius: CGFloat
    var numRows: Int
    var numColumns: Int
    
    init(boardModel: TetrisBoardModel) {
        gapBetweenCenters = boardModel.getBlockSize()
        markerRadius = CGFloat(1.0)
        self.numRows = boardModel.numRows
        self.numColumns = boardModel.numColumns
        super.init(frame: boardModel.frame)
        backgroundColor = UIColor.clear
    }

 
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        print("in TetrisBoard: rect is \(rect)")
        super.draw(rect)
        var circles = [UIBezierPath]()
        for row in 0 ..< numRows+1 {
            let y = gapBetweenCenters * CGFloat(row)
            for column in 0 ..< numColumns+1 {
                let x = gapBetweenCenters * CGFloat(column)
                let center = CGPoint(x: x, y: y)
                let marker = UIBezierPath(arcCenter: center, radius: markerRadius,
                                          startAngle: 0.0, endAngle: CGFloat(2.0 * Double.pi), clockwise: false)
                circles.append(marker)
            }
        }
        UIColor.lightGray.setFill()
        for circle in circles {
            circle.fill()
        }
    }


    required init?(coder aDecoder: NSCoder) {
        return nil
    }

}

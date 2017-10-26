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
    var containingRect: CGRect!
    
    init(withFrame frame: CGRect, numRows: Int, numCols: Int, circleRadius: Int) {
        containingRect = frame
        gapBetweenCenters = CGFloat(frame.width / CGFloat(numCols))
        markerRadius = CGFloat(circleRadius)
        self.numRows = numRows
        self.numColumns = numCols
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }

 
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        print("in TetrisBoard: rect is \(containingRect)")
        super.draw(containingRect)
        var circles = [UIBezierPath]()
        for row in 0 ..< numRows+1 {
            let y = gapBetweenCenters * CGFloat(row) + frame.minY
            for column in 0 ..< numColumns+1 {
                let x = gapBetweenCenters * CGFloat(column) + frame.minX
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

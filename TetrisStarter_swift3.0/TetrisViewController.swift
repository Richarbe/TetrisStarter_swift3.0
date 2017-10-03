//
//  TetrisViewController.swift
//  TetrisStarter
//
//  Created by AAK on 9/26/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class TetrisViewController: UIViewController {
    
    let blockSize = 30
    var tetrisBoard: TetrisBoardView!
    var block: TetrisBlockView!
    var inMotion = false
    var paused = false

    
    @IBAction func didTapTheView(_ sender: UITapGestureRecognizer) {
        if !inMotion  {
            inMotion = true
            block.startDescent()
            return
        }

        let location = sender.location(in: tetrisBoard)
        print(location)
        if location.x < tetrisBoard.bounds.width / CGFloat(2.0) {
            block.rotateCounterClockwise()
        } else {
            block.rotateClockWise()
        }
     }
    
    @IBAction func didSwipeView(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            block.moveLeft()
        } else {
            block.moveRight()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let grid = JTetrisGrid()
        let centerX = Int(UIScreen.main.bounds.size.width) / blockSize * blockSize / 2
        block = TetrisBlockView(color: UIColor.orange, grid: grid, blockSize: blockSize,
                                    startY: 100.0, boardCenterX: CGFloat(centerX))
        
        tetrisBoard = TetrisBoardView(withFrame: UIScreen.main.bounds, blockSize: blockSize, circleRadius: 1 )
        view.addSubview(tetrisBoard)
        print("Center of block before animation: \(block.center)")

        print("Bounds of main screen is \(UIScreen.main.bounds)")
        view.addSubview(block)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

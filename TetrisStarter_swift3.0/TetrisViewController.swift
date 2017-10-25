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
    var holdBlock: TetrisBlockView!
    var inMotion = false
    var paused = false

    
    @IBAction func didTapTheView(_ sender: UITapGestureRecognizer) {
        if !inMotion  {
            inMotion = true
            newBlock(gridType: Int(arc4random_uniform(6)))
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
        NotificationCenter.default.addObserver(self, selector: #selector(TetrisViewController.onBlockLand), name: Constants.BLOCK_LAND_NOTIFY, object: nil)
        tetrisBoard = TetrisBoardView(withFrame: UIScreen.main.bounds, blockSize: blockSize, circleRadius: 1 )
        view.addSubview(tetrisBoard)
        newBlock(gridType: 2)
        
    }
    
    func onBlockLand() {
        print("View Controller Notified")
        newBlock(gridType: Int(arc4random_uniform(6)))
        block.startDescent()
    }
    
    func newBlock(gridType: Int) {
        let num = gridType
        var grid:TetrisBlockModel
        switch num{
        case 0:
            grid = JTetrisGrid()
        case 1:
            grid = LTetrisGrid()
        case 2:
            grid = ZTetrisGrid()
        case 3:
            grid = STetrisGrid()
        case 4:
            grid = ITetrisGrid()
        case 5:
            grid = OTetrisGrid()
        default:
            print("No grid type " + String(num))
            grid = JTetrisGrid()
        }
        let centerX = Int(UIScreen.main.bounds.size.width) / blockSize / 2 * blockSize
        if holdBlock != nil {
            block = holdBlock
            block.moveToPosition(x: centerX, y: 100)
            
            block.startDescent()
        }
        holdBlock = TetrisBlockView(color: UIColor.orange, grid: grid, blockSize: blockSize,
                                y: 50.0, x: CGFloat(centerX-150))
        

        //print("Center of block before animation: \(block.center)")
        
        //print("Bounds of main screen is \(UIScreen.main.bounds)")
        view.addSubview(holdBlock)
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

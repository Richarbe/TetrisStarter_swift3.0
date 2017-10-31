//
//  TetrisViewController.swift
//  TetrisStarter
//
//  Created by AAK on 9/26/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class TetrisViewController: UIViewController {
    
    var boardFrame: CGRect!
    let leftMargin = 20
    let rightMargin = 20
    let topMargin = 20
    let bottomMargin = 20
    let gridWidth = 12
    let gridHeight = 20
    var tetrisBoardView: TetrisBoardView!
    var tetrisBoard: TetrisBoardModel!
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

        let location = sender.location(in: tetrisBoardView)
        //print(location)
        if location.x < tetrisBoardView.bounds.width / CGFloat(2.0) {
            block.rotateCounterClockwise()
        } else {
            block.rotateClockWise()
        }
     }
    
    @IBAction func didSwipeView(_ sender: UISwipeGestureRecognizer) {
        if block != nil{
            if sender.direction == .left {
                block.moveLeft()
            } else if sender.direction == .right {
                block.moveRight()
            } else if sender.direction == .down {
                //TODO send block down
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(TetrisViewController.onBlockLand), name: Constants.BLOCK_LAND_NOTIFY, object: nil)
        let boardWidth = Int(UIScreen.main.bounds.maxX) - rightMargin - leftMargin
        let boardHeight = Int(UIScreen.main.bounds.maxY) - bottomMargin - topMargin
        boardFrame = CGRect(x: leftMargin,
                            y: topMargin,
                            width: boardWidth,
                            height: boardHeight)
        
        tetrisBoard = TetrisBoardModel(frame: boardFrame, numRows: gridHeight, numColumns: gridWidth)
        tetrisBoardView = TetrisBoardView(boardModel: tetrisBoard)
        view.addSubview(tetrisBoardView)
        newBlock(gridType: 2)
        
    }
    
    func onBlockLand() {
        //print("View Controller Notified")
        newBlock(gridType: Int(arc4random_uniform(6)))
        block.startDescent()
    }
    
    func newBlock(gridType: Int) {
        let num = gridType
        var grid:TetrisBlockModel
        switch num{
        case 0:
            grid = JTetrisGrid(board: tetrisBoard)
            print("New JBlock Produced")
        case 1:
            grid = LTetrisGrid(board: tetrisBoard)
            print("New LBlock Produced")
        case 2:
            grid = ZTetrisGrid(board: tetrisBoard)
            print("New ZBlock Produced")
        case 3:
            grid = STetrisGrid(board: tetrisBoard)
            print("New SBlock Produced")
        case 4:
            grid = ITetrisGrid(board: tetrisBoard)
            print("New IBlock Produced")
        case 5:
            grid = OTetrisGrid(board: tetrisBoard)
            print("New OBlock Produced")
        default:
            print("No grid type " + String(num))
            grid = JTetrisGrid(board: tetrisBoard)
            print("New JBlock Produced by default")
        }
        let centerX = Int(UIScreen.main.bounds.size.width) / 2
        if holdBlock != nil {
            print("dropping previous held block...")
            block = holdBlock
            block.moveToPosition(x: centerX, y: 100)
            
            block.startDescent()
        }
        holdBlock = TetrisBlockView(grid: grid, y: 50.0, x: CGFloat(centerX-150))
        

        //print("Center of block before animation: \(block.center)")
        
        //print("Bounds of main screen is \(UIScreen.main.bounds)")
        tetrisBoardView.addSubview(holdBlock)
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

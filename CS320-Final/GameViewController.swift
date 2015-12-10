//
//  GameViewController.swift
//  CS320-Final
//
//  Created by Aaron King on 12/1/15.
//  Copyright (c) 2015 Aaron King. All rights reserved.
//

import UIKit
import SpriteKit

var gameScore = 0

class GameViewController: UIViewController {
    
    @IBOutlet weak var clock: UILabel!
    
    var count = 30
    var timer:NSTimer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clock.text = "Start!"
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            let myScene = GameScene(size: skView.frame.size)
            skView.presentScene(myScene)
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    
    func update() {
        
        if(count >= 0)
        {
            clock.text = "Time: " + String(count--)
        } else {
            timer.invalidate()
            clock.text = ""
        }
        
    }
    
//    func presentScore(){
//        let refreshAlert = UIAlertController(title: "Game Over!", message: "Your Score is: \(gameScore)", preferredStyle: UIAlertControllerStyle.Alert)
//        
//        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
//        }))
//        
//        presentViewController(refreshAlert, animated: true, completion: nil)
//    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

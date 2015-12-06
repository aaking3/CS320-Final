//
//  GameScene.swift
//  CS320-Final
//
//  Created by Aaron King on 12/1/15.
//  Copyright (c) 2015 Aaron King. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var enemy = SKSpriteNode(imageNamed: "Images/ISIS.png")
    var player: SKSpriteNode
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.addChild(enemy)
        

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */ 
        
        for touch in touches {
           let location = touch.locationInNode(self)
            
        }
    }
    
    func addGun(){
        player  = SKSpriteNode(imageNamed: "player.png")
        player.setScale(0.25)

    }
    
    func bullets(){
        var Bullet = SKSpriteNode(imageNamed: "bullet.png")
        Bullet.zPosition = -5
        Bullet.position = CGPointMake(player.position.x, player.position.y)
        self.addChild(Bullet)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

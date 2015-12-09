//
//  GameScene.swift
//  CS320-Final
//
//  Created by Aaron King on 12/1/15.
//  Copyright (c) 2015 Aaron King. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ship = SKSpriteNode()
    var bullet = SKSpriteNode()
    var moveUp = SKAction()
    var moveDown = SKAction()
    var lastPlane: CFTimeInterval = 0
    var lastYieldTimeInterval = NSTimeInterval()
    var lastUpdateTimeInterval = NSTimeInterval()
    var enemiesDestroyer: Int = 0
    
    let enemyMask: UInt32 = 0x1 << 1
    let bulletMask:UInt32 = 0x1 << 0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        self.addShip()
        var enemyTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: ("spawnEnemy"), userInfo: nil, repeats: true)
        var bulletTimer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: ("spawnBullet"), userInfo: nil, repeats: true)
        self.spawnEnemy()
    }
    
    func addShip(){
        ship = SKSpriteNode(imageNamed: "Spaceship")
        ship.setScale(0.25)
        ship.zRotation = CGFloat(-M_PI/1000)
        ship.physicsBody = SKPhysicsBody(rectangleOfSize: ship.size)
        ship.physicsBody?.categoryBitMask = UInt32(enemyMask)
        ship.physicsBody?.contactTestBitMask = UInt32(bulletMask)
        self.physicsBody?.dynamic = true
        ship.physicsBody?.collisionBitMask = 0
        ship.position = CGPointMake(self.size.width/2, self.size.height/15)
        ship.name =  "ship"
        self.addChild(ship)
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
    }
    
    func spawnBullet(){
        bullet = SKSpriteNode(imageNamed: "Bullet.png")
        bullet.zPosition = -5
        bullet.position = CGPointMake(ship.position.x, ship.position.y)
        let action = SKAction.moveToY(self.size.height + 40, duration: 0.6)
        bullet.runAction(SKAction.repeatActionForever(action))
        self.addChild(bullet)
    }
    
    func spawnEnemy(){
        var enemy = SKSpriteNode(imageNamed: "ISIS.png")
        var min = self.size.width/8
        var max = self.size.width-20
        var spawnPosition = UInt32(max - min)
        var xPosition = CGFloat(arc4random_uniform(spawnPosition))
        enemy.physicsBody?.dynamic = true
        enemy.physicsBody?.categoryBitMask = enemyMask
        enemy.physicsBody?.contactTestBitMask = bulletMask
        enemy.physicsBody?.collisionBitMask = 0
        enemy.position = CGPoint(x: xPosition, y: self.size.height)
        let action = SKAction.moveToY(-40, duration: 3.0)
        enemy.runAction(SKAction.repeatActionForever(action))
        self.addChild(enemy)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)
            
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */

    }
}

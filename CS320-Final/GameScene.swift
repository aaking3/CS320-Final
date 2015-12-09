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
        let minX = enemy.size.width/2
        let maxX = self.frame.size.width - enemy.size.width/2
        let rangeX = maxX-minX
        let spawnPosition:CGFloat = (CGFloat)(arc4random())%CGFloat(rangeX) + CGFloat(minX)
        enemy.position = CGPointMake(spawnPosition, self.frame.size.height+enemy.size.height)
        
        // Collision of enemy and bullet
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        enemy.physicsBody?.dynamic = true
        enemy.physicsBody?.categoryBitMask = enemyMask
        enemy.physicsBody?.contactTestBitMask = bulletMask
        enemy.physicsBody?.collisionBitMask = 0
        
        self.addChild(enemy)
        
        let minDuration = 2
        let maxDuration = 4
        let rangeDuration = maxDuration - minDuration
        let duration = Int(arc4random())%Int(rangeDuration) + Int(minDuration)
        //Creation Action
        var actionArray = [SKAction]()
        actionArray.append(SKAction.moveTo(CGPointMake(spawnPosition, -enemy.size.height), duration: NSTimeInterval(duration)))
        actionArray.append(SKAction.removeFromParent())
        enemy.runAction(SKAction.sequence(actionArray))

    }
    
    func updateSinceLastUpdate(timeSinceLastUpdate: CFTimeInterval){
        lastYieldTimeInterval += timeSinceLastUpdate
        if(lastYieldTimeInterval > 1){
            lastYieldTimeInterval = 0
            spawnEnemy()
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    
    func addVector(x: CGPoint, y: CGPoint)->CGPoint{
        return CGPointMake(x.x + y.x, x.y + y.y)
    }
    
    func subtractVector(x: CGPoint, y: CGPoint)->CGPoint{
        return CGPointMake(x.x - y.x, x.y - y.y)
    }
    
    func multiplyVector(x: CGPoint, y: CGPoint)->CGPoint{
        return CGPointMake(x.x * y.x, x.y * y.y)
    }
    
    func lengthOfVector(x: CGPoint)->CGFloat{
        return CGFloat(sqrtf(CFloat(x.x)*CFloat(x.x)+CFloat(x.y)*CFloat(x.y)))
    }
    
    func vectorNormalize(x:CGPoint)->CGPoint{
        var length: CGFloat = lengthOfVector(x)
        return CGPointMake(x.x / length, x.y/length)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        var timeSinceLastUpdate = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        if(timeSinceLastUpdate > 1){
            timeSinceLastUpdate = 1/60
            lastUpdateTimeInterval = currentTime
        }
        updateSinceLastUpdate(timeSinceLastUpdate)
    }
}

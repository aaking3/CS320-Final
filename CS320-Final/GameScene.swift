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
    var enemiesDestroyed: Int = 0
    var count = 30
    
    let enemyMask: UInt32 = 0x1 << 1
    let bulletMask:UInt32 = 0x1 << 0
    
    override func didMoveToView(view: SKView) {
        
//        let bgImage = SKSpriteNode(imageNamed: "Background.png")
//        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2)
//        bgImage.size = (scene?.size)!
//        self.addChild(bgImage)
        self.backgroundColor = UIColor.blackColor()
        self.addShip()
        self.spawnEnemy()
        
        _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    func update() {
        
        if(count >= 0)
        {
            count--
        } else {
            gameScore = enemiesDestroyed
            let transition:SKTransition = SKTransition.flipHorizontalWithDuration(0.5)
            let endOfGameScene:SKScene = EndOfGameScene(size: self.size, timeUp: true)
            self.view?.presentScene(endOfGameScene, transition: transition)
            
        }
        
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
//        bullet.position = CGPointMake(ship.position.x, ship.position.y)
        let action = SKAction.moveToY(self.size.height + 40, duration: 0.6)
        bullet.runAction(SKAction.repeatActionForever(action))
        self.addChild(bullet)
    }
    
    func spawnEnemy(){
        let enemy = SKSpriteNode(imageNamed: "ISIS.png")
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
        
        if let touch = touches.first as UITouch? {
        
        let location:CGPoint = touch.locationInNode(self)
        
        let bullet:SKSpriteNode = SKSpriteNode(imageNamed: "Bullet")
//        bullet.position = ship.position
        bullet.position = CGPointMake(self.size.width/2, 120)
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
        bullet.physicsBody?.dynamic = true
        bullet.physicsBody?.categoryBitMask = bulletMask
        bullet.physicsBody?.contactTestBitMask = enemyMask
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        let offset:CGPoint = subtractVector(location, y: bullet.position)
        if offset.y < 0 {
            return
        }
        self.addChild(bullet)
        
        let direction:CGPoint = vectorNormalize(offset)
        
        let shotLength:CGPoint = vectorMultiply(direction, b: 5000)
        let finalDestination:CGPoint = addVector(shotLength, y: bullet.position)
        let velocity = 568/1
        let moveDuration:Float = Float(self.size.width) / Float(velocity)
        var actionArray = [SKAction]()
        actionArray.append(SKAction.moveTo(finalDestination, duration: NSTimeInterval(moveDuration)))
        actionArray.append(SKAction.removeFromParent())
        bullet.runAction(SKAction.sequence(actionArray))
        }
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & bulletMask) != 0 && (secondBody.categoryBitMask & enemyMask) != 0){
            explosion(firstBody.node as! SKSpriteNode, enemy: secondBody.node as! SKSpriteNode)
        }
    }
    
    func explosion(bullet:SKSpriteNode, enemy: SKSpriteNode){
        bullet.removeFromParent()
        enemy.removeFromParent()
        
        enemiesDestroyed++
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
    func vectorMultiply(a:CGPoint, b:CGFloat) ->CGPoint{
        return CGPointMake(a.x*b, a.y*b)
    }
    
    func lengthOfVector(x: CGPoint)->CGFloat{
        return CGFloat(sqrtf(CFloat(x.x)*CFloat(x.x)+CFloat(x.y)*CFloat(x.y)))
    }
    
    func vectorNormalize(x:CGPoint)->CGPoint{
        let length: CGFloat = lengthOfVector(x)
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

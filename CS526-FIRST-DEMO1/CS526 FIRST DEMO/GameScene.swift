//
//  GameScene.swift
//  CS526 FIRST DEMO
//
//  Created by User on 9/15/15.
//  Copyright (c) 2015 User. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    enum GameState {
        case GameRunning
        case GameOver
    }
    var score = 0;
    let playableRect : CGRect
    let backgroundLayerNode = SKNode()
    let informationLayerNode = SKNode()
    let chararterLayerNode = SKNode()
    let gemLayerNode = SKNode()
    var dt : NSTimeInterval = 0
    var lastUpdateTime : NSTimeInterval = 0
    var lastTouchPosition = CGPoint?()
    let characterMovePointsPerSec : CGFloat =  800
    var velocity = CGPointZero
    let UIlayerNode = SKNode()
    var scoreLabel = SKLabelNode(fontNamed: "Arial")
    let UIbackgroundHeight: CGFloat = 90
    var Lifebar = SKSpriteNode()
    var LifeLosing = SKAction()
    var gameState = GameState.GameRunning;
    let resultLable = SKLabelNode()
    let gameOverLabel = SKLabelNode()
    var maxAspectRatio = CGFloat()
    var playableMargin = CGFloat()
    var maxAspectRatioWidth = CGFloat()
    let charater = SKSpriteNode(imageNamed: "worker")
    //set the swipe length
    var touchLocation = CGPointZero
    override init(size: CGSize) {
        gameState = .GameRunning
        maxAspectRatio = 16.0/9.0 // iPhone 5"
        maxAspectRatioWidth = size.height / maxAspectRatio
        playableMargin = (size.width - maxAspectRatioWidth) / 2.0
        playableRect = CGRect(x: playableMargin, y: 0,
            width: size.width - playableMargin/2,
            height: size.height - UIbackgroundHeight)
        super.init(size: size)
    }
    override func didEvaluateActions() {
        collisionCheck();
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMoveToView(view: SKView) {
        setupSceneLayer()
        setupGemAction()
    }
    override func update(currentTime: NSTimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        if let lastTouch = lastTouchPosition {
            let diff = lastTouch - charater.position
            if (diff.length() <= characterMovePointsPerSec * CGFloat(dt)) {
                charater.position = lastTouchPosition!
                velocity = CGPointZero
            } else {
                moveSprite(charater, velocity: velocity)
            }
        }
        if(Lifebar.size.width==0 && gameState == .GameRunning){
            gameState = GameState.GameOver
        }
        if(Lifebar.size.width <= size.width/2 && Lifebar.color == UIColor.greenColor()){
            Lifebar.color = UIColor.orangeColor()
        }
        if(Lifebar.size.width <= size.width/5 && Lifebar.color == UIColor.orangeColor()){
            Lifebar.color = UIColor.redColor()
        }
        switch(gameState){
        case (.GameOver): restartGame(size, gameover: gameOverLabel, result: resultLable)
            default: break
        }
    }
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
////        if(charater.position.x == size.width/2 || charater.position.x == size.width/3*2 || charater.position.x == size.width/3){
//            let touch = touches.first! as UITouch
//            let touchLocation = touch.locationInNode(chararterLayerNode)
////            lastTouchPosition = moveCharacter(charater.position, touchPosition: touchLocation)
////            moveCharaterToward(lastTouchPosition!)
////       r }
//    }
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        let touch = touches.first! as UITouch
////        let location = touch.locationInNode(characterLayerNode)
//        let location = touch.locationInNode(chararterLayerNode)
//        let touchThreshold: CGFloat = 10
//        let swipe = CGVector(dx: location.x-touchLocation.x, dy: location.y-touchLocation.y)
//        if sqrt(swipe.dx*swipe.dx+swipe.dy+swipe.dy)>touchThreshold
//       {
//            lastTouchPosition = moveCharacter(charater.position, touchPosition: location)
//            moveCharaterToward(lastTouchPosition!)
//
//        }
//    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let location = touch.locationInNode(chararterLayerNode)
        touchLocation = location
        //        touchTime = CACurrentTime()
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //        let touchTimeThreshold: CFTimeInterval = 0.3
        let touchDistanceThreshold: CGFloat = 3
        //        if CACurrentMediaTime() - touchTime < TouchTimeThreshold
        let touch = touches.first! as UITouch
        let location = touch.locationInNode(chararterLayerNode)
        let swipe = CGVector(dx:location.x - touchLocation.x,dy:location.y - touchLocation.y)
        let swipeLength = sqrt(swipe.dx * swipe.dx + swipe.dy * swipe.dy)
        if( swipeLength > touchDistanceThreshold){
            lastTouchPosition = moveCharacter(charater.position, touchPosition: location)
            moveCharaterToward(lastTouchPosition!)
        }
    }

    func setupSceneLayer() {
        addChild(backgroundLayerNode)
        addChild(chararterLayerNode)
        addChild(UIlayerNode)
        addChild(gemLayerNode)
        setupUI()
        backgroundColor = SKColor.grayColor()
    }
    func setupUI() {
        charater.position = CGPoint(x: size.width/2, y: 1/5*size.height)
        charater.zPosition = 20
        charater.name = "charater"
        chararterLayerNode.addChild(charater)
        let backgroundSize = CGSize(width: size.width, height: UIbackgroundHeight)
        let UIbackground = SKSpriteNode(color: UIColor.blackColor(), size: backgroundSize)
        UIbackground.anchorPoint = CGPointZero
        UIbackground.position = CGPoint(x: 0, y: size.height - UIbackgroundHeight)
        UIbackground.zPosition = 20
        UIlayerNode.addChild(UIbackground)
        scoreLabel.fontColor = UIColor.grayColor();
        scoreLabel.text = "Score: 0 "
        scoreLabel.name = "scoreLabel"
        scoreLabel.fontSize = 50
        scoreLabel.zPosition = 60
        scoreLabel.verticalAlignmentMode = .Center
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height - scoreLabel.frame.height)
        UIlayerNode.addChild(scoreLabel)
        Lifebar.zPosition = 60
        Lifebar.size = CGSizeMake(size.width - playableMargin*2, 10)
        Lifebar.anchorPoint = CGPointZero
        Lifebar.position = CGPoint(x: playableMargin, y: size.height - UIbackgroundHeight)
        Lifebar.color = UIColor.greenColor()
        LifeLosing = SKAction.scaleXTo(0, duration: 30)
        Lifebar.runAction(LifeLosing)
        UIlayerNode.addChild(Lifebar)
        gameOverLabel.name = "gameOverLabel"
        gameOverLabel.fontSize = 70
        gameOverLabel.fontColor = SKColor.blackColor()
        gameOverLabel.horizontalAlignmentMode = .Center
        gameOverLabel.verticalAlignmentMode = .Center
        gameOverLabel.position = CGPointMake(size.width / 2, size.height / 2 + 50)
        gameOverLabel.zPosition = 60
        gameOverLabel.text = "GAME OVER"
        resultLable.name = "resultLable"
        resultLable.fontSize = 70
        resultLable.zPosition = 60
        resultLable.fontColor = SKColor.blackColor()
        resultLable.horizontalAlignmentMode = .Center
        resultLable.verticalAlignmentMode = .Center
        resultLable.position = CGPointMake(size.width / 2, size.height / 2 - 50)

    }
    func setupSceneLayerAgain() {
        charater.position = CGPoint(x: size.width/2, y: 1/5*size.height)
        chararterLayerNode.addChild(charater)
        let backgroundSize = CGSize(width: size.width, height: UIbackgroundHeight)
        let UIbackground = SKSpriteNode(color: UIColor.blackColor(), size: backgroundSize)
        UIbackground.anchorPoint = CGPointZero
        UIbackground.position = CGPoint(x: 0, y: size.height - UIbackgroundHeight)
        UIbackground.zPosition = 20
        UIlayerNode.addChild(UIbackground)
        scoreLabel.fontColor = UIColor.grayColor();
        scoreLabel.text = "Score: 0"
        score = 0
        UIlayerNode.addChild(scoreLabel)
        Lifebar.size = CGSizeMake(size.width - playableMargin*2, 10)
        UIlayerNode.addChild(Lifebar)
        Lifebar.color = UIColor.greenColor()
        LifeLosing = SKAction.scaleXTo(0, duration: 30)
        Lifebar.runAction(LifeLosing)
    }
    func gemfall1(){
        let yellowGem = SKSpriteNode(imageNamed: "Diamond-100.png")
        yellowGem.name = "yellowGem"
        yellowGem.zPosition = 10
        yellowGem.position = CGPoint(x: size.width/2, y: size.height + CGFloat(yellowGem.size.height))
        gemLayerNode.addChild(yellowGem)
        let testActinon = SKAction.moveBy(CGVector(dx: 0, dy: -size.height-CGFloat(yellowGem.size.height)), duration: 5)
        let remove = SKAction.removeFromParent()
        yellowGem.runAction(SKAction.sequence([testActinon, remove]))
        
    }
    func gemfall2(){
        let yellowGem = SKSpriteNode(imageNamed: "Diamond-100.png")
        yellowGem.name = "yellowGem"
        yellowGem.zPosition = 10
        yellowGem.position = CGPoint(x: size.width/3, y: size.height + CGFloat(yellowGem.size.height))
        gemLayerNode.addChild(yellowGem)
        let testActinon = SKAction.moveBy(CGVector(dx: 0, dy: -size.height-CGFloat(yellowGem.size.height)), duration: 1)
        let remove = SKAction.removeFromParent()
        yellowGem.runAction(SKAction.sequence([testActinon, remove]))
    }
    func gemfall3(){
        let yellowGem = SKSpriteNode(imageNamed: "Diamond-100.png")
        yellowGem.name = "yellowGem"
        yellowGem.zPosition = 10
        yellowGem.position = CGPoint(x: size.width/3*2, y: size.height + CGFloat(yellowGem.size.height))
        gemLayerNode.addChild(yellowGem)
        let testActinon = SKAction.moveBy(CGVector(dx: 0, dy: -size.height-CGFloat(yellowGem.size.height)), duration: 1)
        let remove = SKAction.removeFromParent()
        yellowGem.runAction(SKAction.sequence([testActinon, remove]))
    }
    func gemfall() {
        let yellowGem = SKSpriteNode(imageNamed: "Diamond-100.png")
        yellowGem.name = "yellowGem"
        yellowGem.zPosition = 10
        let lane: Int = randomInRange(1...3)
        if(lane == 1) {
            yellowGem.position = CGPoint(x: size.width/3, y: size.height + CGFloat(yellowGem.size.height))
        } else if(lane == 2) {
            yellowGem.position = CGPoint(x: size.width/2, y: size.height + CGFloat(yellowGem.size.height))
        } else {
            yellowGem.position = CGPoint(x: size.width/3*2, y: size.height + CGFloat(yellowGem.size.height))
        }
        gemLayerNode.addChild(yellowGem)
        let testActinon = SKAction.moveBy(CGVector(dx: 0, dy: -size.height-CGFloat(yellowGem.size.height)), duration: 1)
        let remove = SKAction.removeFromParent()
        yellowGem.runAction(SKAction.sequence([testActinon, remove]))
    }

    func collisionCheck() {
        var hitGem: [SKSpriteNode] = []
        gemLayerNode.enumerateChildNodesWithName("yellowGem") { node, _ in
            let yellowGem = node as! SKSpriteNode
            if CGRectIntersectsRect(CGRectInset(node.frame,20, 20), self.charater.frame){
                hitGem.append(yellowGem)
            }
        }
        for yellowGem in hitGem {
            characterHitGem(yellowGem)
        }
        
    }
    func characterHitGem(gem: SKSpriteNode){
        gem.removeFromParent()
        increaseScoreBy(250)
    }
    
    func moveCharacter(position: CGPoint, touchPosition: CGPoint) ->CGPoint{
        if(velocity == CGPointZero) {
            if((touchPosition.x > position.x)&&(position.x < size.width/3*2)){
                return CGPoint(x: charater.position.x + size.width/6, y: position.y)
            }
            if((touchPosition.x < position.x)&&(position.x > size.width/3)){
                return CGPoint(x: charater.position.x-size.width/6, y: position.y)
            }
        }
        return position
    }
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = velocity * CGFloat(dt)
        sprite.position += amountToMove
    }
    func moveCharaterToward(location: CGPoint) {
        let offset = location - charater.position
        let direction = offset.normalize()
        velocity = direction * characterMovePointsPerSec
    }
    func increaseScoreBy(plus: Int){
        score += plus
        scoreLabel.text = "Score: \(score)"
    }
    func setupGemAction(){
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(gemfall),SKAction.waitForDuration(2.0)])))
    }
    func restartGame(size: CGSize, gameover: SKLabelNode, result: SKLabelNode){
        result.text = "Your Score is \(score)"
        let gameoverscene = GameOverScene(size: size, gameover: gameOverLabel, result: resultLable)
        gameoverscene.scaleMode = scaleMode
        let reveal = SKTransition.fadeWithDuration(0.5)
        view?.presentScene(gameoverscene, transition: reveal)
    }
}

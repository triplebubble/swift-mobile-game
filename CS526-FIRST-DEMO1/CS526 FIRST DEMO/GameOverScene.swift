//
//  GameOverScene.swift
//  CS526 FIRST DEMO
//
//  Created by User on 9/29/15.
//  Copyright © 2015 User. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    let gameOverlabel: SKLabelNode
    let resultlabel: SKLabelNode
    init(size: CGSize, gameover: SKLabelNode, result: SKLabelNode){
        self.gameOverlabel = gameover
        self.resultlabel = result
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.grayColor()
        self.addChild(gameOverlabel)
        self.addChild(resultlabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let block = SKAction.runBlock {
            let myScene = GameScene(size: self.size)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.fadeWithDuration(0.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
        self.runAction(block)
    }

}

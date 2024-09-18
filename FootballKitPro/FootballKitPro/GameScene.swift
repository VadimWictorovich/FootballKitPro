//
//  GameScene.swift
//  FootballKitPro
//
//  Created by Вадим Игнатенко on 17.09.24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    
    // NODE
    var firstLayerBg: SKSpriteNode!
    var secondLayerBg: SKSpriteNode!
    var firstPlayerNode: SKSpriteNode!
    var secondPlayerNode: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        firstPlayerNode = SKSpriteNode(imageNamed: "player1_1")
        firstPlayerNode.position = CGPoint(x: 0, y: -200)
        
        secondPlayerNode = SKSpriteNode(imageNamed: "player2_1")
        secondPlayerNode.position = CGPoint(x: 0, y: 200)
        
        firstLayerBg = SKSpriteNode(imageNamed: "bgColor1")
        
        secondLayerBg = SKSpriteNode(imageNamed: "bg")
        
        addChild(firstLayerBg)
        addChild(secondLayerBg)
        addChild(firstPlayerNode)
        addChild(secondPlayerNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            
            let moveAction = SKAction.move(to: touchLocation, duration: 0.4)
            firstPlayerNode.run(moveAction)
        }
    }
}

//
//  GameScene.swift
//  FootballKitPro
//
//  Created by Вадим Игнатенко on 17.09.24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // TEXTURE
    var firstBgTexture: SKTexture!
    var secondBgTexture: SKTexture!
    
    // SPRITE NODES
    var firstBgNode = SKSpriteNode()
    var secondBgNode = SKSpriteNode()
    
    var firstPlayerNode: SKSpriteNode!
    var secondPlayerNode: SKSpriteNode!
    
    // SPRITE OBJECTS
    var firstBgObjects = SKNode()
    var secondBgObjects = SKNode()
    
    override func didMove(to view: SKView) {
        firstPlayerNode = SKSpriteNode(imageNamed: "player1_1")
        firstPlayerNode.position = CGPoint(x: 0, y: -200)
        
        secondPlayerNode = SKSpriteNode(imageNamed: "player2_1")
        secondPlayerNode.position = CGPoint(x: 0, y: 200)
        
        firstBgTexture = SKTexture(imageNamed: "bgColor1")
        secondBgTexture = SKTexture(imageNamed: "bg")
       
        createObjects()
        createGame()
        addChild(firstPlayerNode)
        addChild(secondPlayerNode)
    }
    
    func createObjects() {
        self.addChild(firstBgObjects)
        self.addChild(secondBgObjects)
    }
    
    func createGame() {
        createBg()
    }
    
    func createBg() {
        firstBgTexture = SKTexture(imageNamed: "bgColor1")
        firstBgNode = SKSpriteNode(texture: firstBgTexture)
        firstBgNode.size.height = self.frame.height
        firstBgNode.size.width = self.frame.width
        firstBgNode.zPosition = -1
        firstBgObjects.addChild(firstBgNode)

        secondBgTexture = SKTexture(imageNamed: "bg")
        secondBgNode = SKSpriteNode(texture: secondBgTexture)
        secondBgNode.size.height = self.frame.height
        secondBgNode.size.width = self.frame.width
        secondBgNode.zPosition = -1
        secondBgObjects.addChild(secondBgNode)
    }
    
    
    
    
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            
            let moveAction = SKAction.move(to: touchLocation, duration: 0.4)
            firstPlayerNode.run(moveAction)
        }
    }
}

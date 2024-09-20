//
//  GameScene.swift
//  FootballKitPro
//
//  Created by Вадим Игнатенко on 17.09.24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //MARK: - PROPERTIES
    
    // TEXTURE
    var firstBgTexture: SKTexture!
    var secondBgTexture: SKTexture!
    var firstPlayerTexPos1: SKTexture!
    //var secondPlayerTexPos1: SKTexture!
    var ballTexture: SKTexture!

    // SPRITE NODES
    var firstBgNode = SKSpriteNode()
    var secondBgNode = SKSpriteNode()
    var firstPlayerNode = SKSpriteNode()
    //var secondPlayerNode = SKSpriteNode()
    var ballNode = SKSpriteNode()
    
    // SPRITE OBJECTS
    var firstBgObject = SKNode()
    var secondBgObject = SKNode()
    var firstPlayerOnject = SKNode()
    //var secondPlayerObject = SKNode()
    var ballObject = SKNode()
    
    // BIT MASKS
    //присваиваем категорию для того чтобы система могла отличать объекты
    var playerBitGroup: UInt32 = 0x1 << 1
    var ballBitGroup: UInt32 = 0x1 << 2
    
    // TEXTERES ARRAY FOR ANIMATE
    var firstPlayerRunAnimate = [SKTexture]()
    
    // MARK: - LIFECIRCLE
    
    // ЧТО то ВРОДЕ ЖИЗНЕННОГО ЦИКЛА
    override func didMove(to view: SKView) {
        // Background Texture
        firstBgTexture = SKTexture(imageNamed: "bgColor1")
        secondBgTexture = SKTexture(imageNamed: "bg")
        
        // Heroes Texture
        firstPlayerTexPos1 = SKTexture(imageNamed: "player1_1")
        ballTexture = SKTexture(imageNamed: "ball")
        
        // init methods
        createObjects()
        createGame()
    }
    
    
    
    // MARK: - METHODS
    func createObjects() {
        self.addChild(firstBgObject)
        self.addChild(secondBgObject)
        self.addChild(firstPlayerOnject)
        self.addChild(ballObject)
    }
    
    func createGame() {
        self.physicsWorld.gravity = CGVector(dx: 10, dy: 10)
        createBg()
        createPlayers()
        createBall()
    }
    
    func createBg() {
        firstBgTexture = SKTexture(imageNamed: "bgColor1")
        firstBgNode = SKSpriteNode(texture: firstBgTexture)
        firstBgNode.size.height = self.frame.height - 100
        firstBgNode.size.width = self.frame.width
        firstBgNode.zPosition = -2
        firstBgObject.addChild(firstBgNode)

        secondBgTexture = SKTexture(imageNamed: "bg")
        secondBgNode = SKSpriteNode(texture: secondBgTexture)
        secondBgNode.size.height = self.frame.height - 100
        secondBgNode.size.width = self.frame.width
        secondBgNode.zPosition = -1
        secondBgObject.addChild(secondBgNode)
    }
    
    func addPlayers (player: SKSpriteNode, atPosition position: CGPoint) {
        //передаем текстуру
        firstPlayerNode = SKSpriteNode(texture: firstPlayerTexPos1)
        // Anim players array
        firstPlayerRunAnimate = [SKTexture(imageNamed: "player1_2"),
                                 SKTexture(imageNamed: "player1_3")]
        // реализуем созданный метод анимации и присваиваем в константу
        let firstPlayerAnimate = runAnimatePl(arrayPl: firstPlayerRunAnimate)
        // запускаем анимацию
        firstPlayerNode.run(firstPlayerAnimate)
        // задаем позицию
        firstPlayerNode.position = position
        //задаем размере игроку
        firstPlayerNode.size.height = 110
        firstPlayerNode.size.width = firstPlayerNode.size.height
        // опеределяем в каком слое находится объект
        firstPlayerNode.zPosition = 1
        //настраиваем область действия физического тела
        firstPlayerNode.physicsBody = SKPhysicsBody(rectangleOf: firstPlayerNode.size)
        //настраиваем динамичность (тоесть реагирует на стокновения гравитацию и тд)
        firstPlayerNode.physicsBody?.isDynamic = true
        // делаем массу телу
        firstPlayerNode.physicsBody?.mass = 5.0
        // isResting означает что тело находится в состоянии покоя
        //присваиваем категорию к которой относится объект
        firstPlayerNode.physicsBody?.categoryBitMask = playerBitGroup
        // выбираем категорию с которой объект будет взаимодействовать
        firstPlayerNode.physicsBody?.collisionBitMask = ballBitGroup
        firstPlayerNode.physicsBody?.contactTestBitMask = ballBitGroup
        // добавляем Node в Object
        firstPlayerOnject.addChild(firstPlayerNode)
    }
    
    // метод для анимации бега любого игрока
    func runAnimatePl (arrayPl : [SKTexture]) -> SKAction {
        // анимируем массив
        let animateAction = SKAction.animate(with: arrayPl, timePerFrame: 0.09)
        // анимация на повтор
        let animateRepeat = SKAction.repeatForever(animateAction)
        return animateRepeat
    }
    
    func createPlayers() {
        addPlayers(player: firstPlayerNode, atPosition: CGPoint(x: 0, y: -300))
    }
    
    func createBall() {
        let force = CGVector(dx: 1000, dy: 500) //примерная сила удара
        ballNode = SKSpriteNode(texture: ballTexture)
        ballNode.size.height = 50
        ballNode.size.width = 50
        ballNode.zPosition = 1
        ballNode.physicsBody = SKPhysicsBody(rectangleOf: ballNode.size)
        ballNode.physicsBody?.restitution = 0.7 //упругость для отскока мяча
        ballNode.physicsBody?.friction = 0.2 // трение для контроля скрости удара
        ballNode.physicsBody?.mass = 0.1 //масса мяча
        ballNode.physicsBody?.isDynamic = true
        ballNode.physicsBody?.categoryBitMask = ballBitGroup
        ballNode.physicsBody?.collisionBitMask = playerBitGroup
        ballNode.physicsBody?.contactTestBitMask = playerBitGroup
        ballNode.physicsBody?.applyForce(force)// применяем импульс
        ballNode.position = CGPoint(x: 0, y: -100)
        ballObject.addChild(ballNode)
    }
    
    
    
    // MARK: - ЧЕРНОВИК
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            
            let moveAction = SKAction.move(to: touchLocation, duration: 0.4)
            firstPlayerNode.run(moveAction)
        }
    }
     
}

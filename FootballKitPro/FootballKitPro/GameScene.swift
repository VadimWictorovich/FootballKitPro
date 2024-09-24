//
//  GameScene.swift
//  FootballKitPro
//
//  Created by Вадим Игнатенко on 17.09.24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //MARK: - PROPERTIES
    
    // TEXTURE
    var firstBgTexture: SKTexture!
    var secondBgTexture: SKTexture!
    var firstPlayerTexPos1: SKTexture!
    //var secondPlayerTexPos1: SKTexture!
    var ballTexture: SKTexture!
    var firstGoalTex: SKTexture!
    var secondGoalTex: SKTexture!

    // SPRITE NODES
    var firstBgNode = SKSpriteNode()
    var secondBgNode = SKSpriteNode()
    var firstPlayerNode = SKSpriteNode()
    //var secondPlayerNode = SKSpriteNode()
    var ballNode = SKSpriteNode()
    var firstGoalNode = SKSpriteNode()
    var secondGoalNode = SKSpriteNode()

    
    // SPRITE OBJECTS
    var firstBgObject = SKNode()
    var secondBgObject = SKNode()
    var firstPlayerOnject = SKNode()
    //var secondPlayerObject = SKNode()
    var ballObject = SKNode()
    var firstGoalObj = SKNode()
    var secondGoalObj = SKNode()

    
    // BIT MASKS
    //присваиваем категорию для того чтобы система могла отличать объекты
    var playerBitGroup: UInt32 = 0x1 << 1
    var ballBitGroup: UInt32 = 0x1 << 2
    var wakkBitGroup: UInt32 = 0x1 << 3 // стены
    
    // TEXTERES ARRAY FOR ANIMATE
    var firstPlayerRunAnimate = [SKTexture]()
    
    // MARK: - LIFECIRCLE
    
    // ЧТО то ВРОДЕ ЖИЗНЕННОГО ЦИКЛА
    override func didMove(to view: SKView) {
        // Background Texture
        self.physicsWorld.contactDelegate = self
        firstBgTexture = SKTexture(imageNamed: "bgColor1")
        secondBgTexture = SKTexture(imageNamed: "bg")
        
        // Heroes Texture
        firstPlayerTexPos1 = SKTexture(imageNamed: "player1_1")
        ballTexture = SKTexture(imageNamed: "ball")
        
        // Goal texture
        firstGoalTex = SKTexture(imageNamed: "goal_1")
        secondGoalTex = SKTexture(imageNamed: "goal_2")
        
        // init methods
        createObjects()
        createGame()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let touchLocation = touch.location(in: self)
//        firstPlayerNode.position = touchLocation
//    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        firstPlayerNode.position = touchLocation
    }
    
    // MARK: - METHODS
    func createObjects() {
        self.addChild(firstBgObject)
        self.addChild(secondBgObject)
        self.addChild(firstPlayerOnject)
        self.addChild(ballObject)
        self.addChild(firstGoalObj)
        self.addChild(secondGoalObj)
    }
    
    func createGame() {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        createBg()
        createPlayers()
        createBall()
        createFieldBoundaries()
        addGoal()
    }
    
    func createBg() {
        firstBgTexture = SKTexture(imageNamed: "bgColor1")
        firstBgNode = SKSpriteNode(texture: firstBgTexture)
        firstBgNode.size.height = self.frame.height
        firstBgNode.size.width = self.frame.width
        firstBgNode.zPosition = -2
        firstBgObject.addChild(firstBgNode)

        secondBgTexture = SKTexture(imageNamed: "bg")
        secondBgNode = SKSpriteNode(texture: secondBgTexture)
        secondBgNode.size.height = self.frame.height - 360
        secondBgNode.size.width = self.frame.width - 170
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
        //firstPlayerNode.run(firstPlayerAnimate)
        // задаем позицию
        firstPlayerNode.position = position
        //задаем размере игроку
        firstPlayerNode.size.height = 65
        firstPlayerNode.size.width = firstPlayerNode.size.height
        // опеределяем в каком слое находится объект
        firstPlayerNode.zPosition = 1
        //настраиваем область действия физического тела
        firstPlayerNode.physicsBody = SKPhysicsBody(circleOfRadius: firstPlayerNode.size.width / 2)
        //настраиваем динамичность (тоесть реагирует на стокновения гравитацию и тд)
        firstPlayerNode.physicsBody?.isDynamic = true
        // делаем массу телу
        firstPlayerNode.physicsBody?.mass = 5.0
        // isResting означает что тело находится в состоянии покоя
        //присваиваем категорию к которой относится объект
        firstPlayerNode.physicsBody?.categoryBitMask = playerBitGroup
        // выбираем категорию с которой объект будет взаимодействовать
        firstPlayerNode.physicsBody?.collisionBitMask = ballBitGroup | wakkBitGroup
        firstPlayerNode.physicsBody?.contactTestBitMask = ballBitGroup | wakkBitGroup
        firstBgNode.physicsBody?.restitution = 0.7
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
        ballNode = SKSpriteNode(texture: ballTexture)
        ballNode.size.height = 50
        ballNode.size.width = 50
        ballNode.zPosition = 1
        ballNode.physicsBody = SKPhysicsBody(circleOfRadius: ballNode.size.width / 2)
        ballNode.physicsBody?.restitution = 0.7 //упругость для отскока мяча
        ballNode.physicsBody?.friction = 0.5 // трение для контроля скрости удара
        ballNode.physicsBody?.mass = 0.4 //масса мяча
        ballNode.physicsBody?.linearDamping = 0.1
        ballNode.physicsBody?.isDynamic = true
        ballNode.physicsBody?.categoryBitMask = ballBitGroup
        ballNode.physicsBody?.collisionBitMask = playerBitGroup | wakkBitGroup
        ballNode.physicsBody?.contactTestBitMask = playerBitGroup | wakkBitGroup
        ballNode.physicsBody?.applyImpulse(CGVector(dx: 300, dy: 1500))
        ballNode.position = CGPoint(x: 0, y: -100)
        ballObject.addChild(ballNode)
    }
    
    func addGoal() {
        firstGoalNode = SKSpriteNode(texture: firstGoalTex)
        secondGoalNode = SKSpriteNode(texture: secondGoalTex)
        createGoal(spriteNode: firstGoalNode, position: CGPoint(x: 0, y: -500), obj: firstGoalObj)
        createGoal(spriteNode: secondGoalNode, position: CGPoint(x: 0, y: +537), obj: secondGoalObj)
    }
    
    func createGoal (spriteNode: SKSpriteNode, position: CGPoint, obj: SKNode) {
        spriteNode.size.height = 120
        spriteNode.size.width = 330
        spriteNode.zPosition = 2
        spriteNode.physicsBody = SKPhysicsBody()
        spriteNode.physicsBody?.isDynamic = false
        spriteNode.position = position
        obj.addChild(spriteNode)
    }
    
    // делаем стену
    func createFieldBoundaries() {
        let fieldFrame = secondBgNode.frame  // Границы согласно моему второму бэгрунду
        let border = SKPhysicsBody(edgeLoopFrom: fieldFrame)
        border.friction = 0  // Трение границ
        border.restitution = 1.0  // Упругость, чтобы мяч отскакивал
        self.physicsBody = border
            // Присваиваем категорию границам
        self.physicsBody?.categoryBitMask = wakkBitGroup
        self.physicsBody?.collisionBitMask = ballBitGroup  // Границы сталкиваются только с мячом
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
            let bodyA = contact.bodyA
            let bodyB = contact.bodyB
            print("столкновение")

            // Проверяем, какой объект - игрок, а какой - мяч
            if bodyA.categoryBitMask == playerBitGroup && bodyB.categoryBitMask == ballBitGroup {
                // Если игрок столкнулся с мячом
                if let ball = bodyB.node as? SKSpriteNode {
                    applyImpulseToBall(ball, fromPlayer: bodyA.node)
                }
            } else if bodyA.categoryBitMask == ballBitGroup && bodyB.categoryBitMask == playerBitGroup {
                // Если мяч столкнулся с игроком
                if let ball = bodyA.node as? SKSpriteNode {
                    applyImpulseToBall(ball, fromPlayer: bodyB.node)
                }
            }
        }

        // Функция для добавления импульса мячу
        func applyImpulseToBall(_ ball: SKSpriteNode, fromPlayer player: SKNode?) {
            guard let player = player else { return }
            
            // Рассчитываем направление импульса (например, от игрока в сторону мяча)
            let dx = ball.position.x - player.position.x
            let dy = ball.position.y - player.position.y
            
            // Применяем импульс к мячу
            let impulse = CGVector(dx: dx * 10, dy: dy * 10)
            ball.physicsBody?.applyImpulse(impulse)
        }
    /* какой то бред
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if bodyA.categoryBitMask == ballBitGroup && bodyB.categoryBitMask == playerBitGroup {
            ballNode.physicsBody = bodyA
            firstPlayerNode.physicsBody = bodyB
        } else if bodyB.categoryBitMask == ballBitGroup && bodyA.categoryBitMask == playerBitGroup {
            ballNode.physicsBody = bodyB
            firstPlayerNode.physicsBody = bodyA
        } else {
            // Не интересующее нас столкновение
            return
        }
        
        // Теперь нужно определить направление, в котором мяч будет отлетать
        // Вычисляем вектор от игрока к мячу
        let contactPoint = contact.contactPoint
        let playerPosition = firstPlayerNode.physicsBody?.node!.position
        let ballPosition = ballNode.physicsBody?.node!.position
        
        // Вектор от игрока к мячу
//        let dx = ballPosition.x - playerPosition.x
//        let dy = ballPosition.y - playerPosition.y
//        
//        // Нормализуем вектор, чтобы получить направление
//        let magnitude = sqrt(dx * dx + dy * dy)
//        let direction = CGVector(dx: dx / magnitude, dy: dy / magnitude)
        
        // Применяем импульс к мячу для отталкивания его в направлении от игрока
        let impulseMagnitude: CGFloat = 50.0  // Задаем силу импульса
        let impulse = CGVector(dx: 500, dy: 300)
        
        ballNode.physicsBody?.applyImpulse(impulse)
    }
     */
}

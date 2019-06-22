

import SpriteKit

class GameScene: SKScene,SKPhysicsContactDelegate , ProtocolMainscreen{
    lazy var panda  = Panda()
    lazy var platformFactory = PlatformFactory()
    lazy var sound = SoundManager()
    lazy var bg = Background()
    lazy var appleFactory = AppleFactory()
    let scoreLab = SKLabelNode(fontNamed:"Chalkduster")
    let appLab = SKLabelNode(fontNamed:"Chalkduster")
    let myLabel = SKLabelNode(fontNamed:"Chalkduster")
    var appleNum = 0
    
    var gamec:GameViewController?
    var moveSpeed :CGFloat = 15.0
    var maxSpeed :CGFloat = 50.0
    var distance:CGFloat = 0.0
    var lastDis:CGFloat = 0.0
    var theY:CGFloat = 0.0
    var isLose = false
    override func didMove(to view: SKView) {
        
        let skyColor = SKColor(red:113.0/255.0, green:197.0/255.0, blue:207.0/255.0, alpha:1.0)
        self.backgroundColor = skyColor
        scoreLab.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLab.position = CGPoint(x: 20, y: self.frame.size.height-150)
        scoreLab.text = "run: 0 km"
        self.addChild(scoreLab)
        
        appLab.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        appLab.position = CGPoint(x: 400, y: self.frame.size.height-150)
        appLab.text = "eat: \(appleNum) apple"
        self.addChild(appLab)
        
        myLabel.text = "";
        myLabel.fontSize = 65;
        myLabel.zPosition = 100
        myLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        self.addChild(myLabel)
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody!.categoryBitMask = BitMaskType.scene
        self.physicsBody!.isDynamic = false
        
        panda.position = CGPoint(x: 200, y: 400)
        self.addChild(panda)
        self.addChild(platformFactory)
        platformFactory.screenWdith = self.frame.width
        platformFactory.delegate = self
        platformFactory.createPlatform(3, x: 0, y: 200)
        
        self.addChild(bg)
        
        self.addChild(sound)
       // sound.playBackgroundMusic()
        
        appleFactory.onInit(self.frame.width, y: theY)
        self.addChild( appleFactory )
        
    }
    func didBegin(_ contact: SKPhysicsContact){
        
        //熊猫和苹果碰撞
        if (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (BitMaskType.apple | BitMaskType.panda){
          //  sound.playEat()
            self.appleNum += 1
            if contact.bodyA.categoryBitMask == BitMaskType.apple {
                contact.bodyA.node!.isHidden = true
            }else{
                contact.bodyB.node!.isHidden = true
            }
            
            
        }
        
        //熊猫和台子碰撞
        if (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (BitMaskType.platform | BitMaskType.panda){
            var isDown = false
            var canRun = false
            if contact.bodyA.categoryBitMask == BitMaskType.platform {
                if (contact.bodyA.node as! Platform).isDown {
                    isDown = true
                    contact.bodyA.node!.physicsBody!.isDynamic = true
                    contact.bodyA.node!.physicsBody!.collisionBitMask = 0
                }else if (contact.bodyA.node as! Platform).isShock {
                    (contact.bodyA.node as! Platform).isShock = false
                    downAndUp(contact.bodyA.node!, down: -50, downTime: 0.2, up: 100, upTime: 1, isRepeat: true)
                }
                if contact.bodyB.node!.position.y > contact.bodyA.node!.position.y {
                    canRun=true
                }
                
            }else if contact.bodyB.categoryBitMask == BitMaskType.platform  {
                if (contact.bodyB.node as! Platform).isDown {
                    contact.bodyB.node!.physicsBody!.isDynamic = true
                    contact.bodyB.node!.physicsBody!.collisionBitMask = 0
                    isDown = true
                }else if (contact.bodyB.node as! Platform).isShock {
                    (contact.bodyB.node as! Platform).isShock = false
                    downAndUp(contact.bodyB.node!, down: -50, downTime: 0.2, up: 100, upTime: 1, isRepeat: true)
                }
                if contact.bodyA.node!.position.y > contact.bodyB.node!.position.y {
                    canRun=true
                }
                
            }
            
            panda.jumpEnd = panda.position.y
            if panda.jumpEnd-panda.jumpStart <= -70 {
                panda.roll()
              //sound.playRoll()
                
                if !isDown {
                    downAndUp(contact.bodyA.node!)
                    downAndUp(contact.bodyB.node!)
                }
                
            }else{
                if canRun {
                    panda.run()
                }
                
            }
        }
        
        if (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (BitMaskType.scene | BitMaskType.panda) {
            print("game over")
           let userD = UserDefaults.standard
            
            if(appleNum > userD.integer(forKey: "score")){
                userD.set(appleNum, forKey: "score")
                myLabel.text = "新纪录\(appleNum)分点击重新开始"
            }else if(userD.integer(forKey: "pl") <= 0){
                myLabel.text = "游戏结束得分\(appleNum)分！体力为0点击返回"
            
            }else{
             myLabel.text = "游戏结束得分\(appleNum)分！继续请点击"
            }
            
           
           // sound.playDead()
            isLose = true
           // sound.stopBackgroundMusic()
            

        }
        
        //落地后jumpstart数据要设为当前位置，防止自由落地计算出错
        panda.jumpStart = panda.position.y
    }
    func didEnd(_ contact: SKPhysicsContact){
        panda.jumpStart = panda.position.y
        
    }
    func downAndUp(_ node :SKNode,down:CGFloat = -50,downTime:CGFloat=0.05,up:CGFloat=50,upTime:CGFloat=0.1,isRepeat:Bool=false){
        let downAct = SKAction.moveBy(x: 0, y: down, duration: Double(downTime))
        //moveByX(CGFloat(0), y: down, duration: downTime)
        let upAct = SKAction.moveBy(x: 0, y: up, duration: Double(upTime))
        let downUpAct = SKAction.sequence([downAct,upAct])
        if isRepeat {
            node.run(SKAction.repeatForever(downUpAct))
        }else {
            node.run(downUpAct)
        }
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isLose {
            reSet()
        }else{
            if panda.status != Status.jump2 {
                //sound.playJump()
            }
            panda.jump()
        }
        
        
    }
    //重新开始游戏
    func reSet(){
        self.jspl()
        let userD = UserDefaults.standard
        var pl = userD.integer(forKey: "pl")

        if(pl > 0){
            isLose = false
            panda.position = CGPoint(x: 200, y: 400)
            myLabel.text = ""
            moveSpeed  = 15.0
            distance = 0.0
            lastDis = 0.0
            self.appleNum = 0
            platformFactory.reset()
            appleFactory.reSet()
            platformFactory.createPlatform(3, x: 0, y: 200)
            //sound.playBackgroundMusic()
        }else{
            let currentPL =  userD.integer(forKey: "pl")
            userD.set(0, forKey: "pl")

        myLabel.text = "体力不足！请点击返回"
        }
        
        
        
        
    }
    //游戏开始疲劳-1
    func jspl() {
        let userD = UserDefaults.standard
        let currentPL =  userD.integer(forKey: "pl")
        userD.set(currentPL - 1, forKey: "pl")
            
    }
    override func update(_ currentTime: TimeInterval) {
        if isLose {
            
        }else{
            if panda.position.x < 200 {
                let x = panda.position.x + 1
                panda.position = CGPoint(x: x, y: panda.position.y)
            }
            distance += moveSpeed
            lastDis -= moveSpeed
            var tempSpeed = CGFloat(5 + Int(distance/2000))
            if tempSpeed > maxSpeed {
                tempSpeed = maxSpeed
            }
            if moveSpeed < tempSpeed {
                moveSpeed = tempSpeed
            }
            
            if lastDis < 0 {
                platformFactory.createPlatformRandom()
            }
            distance += moveSpeed
            scoreLab.text = "已走: \(Int(distance/1000*10)/10) 米"
            appLab.text = "已吃: \(appleNum) "
            platformFactory.move(moveSpeed)
            bg.move(moveSpeed/5)
            appleFactory.move(moveSpeed)
        }

    }
    
    func onGetData(_ dist:CGFloat,theY:CGFloat){
        
        self.lastDis = dist
        self.theY = theY
        appleFactory.theY = theY
    }
    
}

protocol ProtocolMainscreen {
    func onGetData(_ dist:CGFloat,theY:CGFloat)
}

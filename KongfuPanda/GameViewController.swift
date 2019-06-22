



import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(_ file : NSString) -> SKNode? {
        
        let path = Bundle.main.path(forResource: file as String, ofType: "sks")
        
        let sceneData = try? Data(contentsOf: URL(fileURLWithPath: path!), options: NSData.ReadingOptions.mappedIfSafe)
        //dataWithContentsOfFile(path!, options: .DataReadingMappedIfSafe, error: nil)
        let archiver = NSKeyedUnarchiver(forReadingWith: sceneData!)
        
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
        archiver.finishDecoding()
        return scene
    }
}

class GameViewController: UIViewController {
   
    @IBOutlet weak var btn: UIButton!
    var gameScene:GameScene?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
                       /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
            var screen = UIScreen.main
            
           //开始按钮
            btn.frame = CGRect(x:screen.bounds.size.width/2+200, y:screen.bounds.size.height-345,width:100,height:100)
            
            btn.addTarget(self, action: Selector("onButtonAction:"), for: .touchUpInside)
            btn.setTitle("返回首页", for: .normal)
            skView.addSubview(btn)
            gameScene = scene
        }
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIInterfaceOrientationMask.allButUpsideDown
        } else {
            return UIInterfaceOrientationMask.all
        }
    }
    //返回事件销毁当前返回
    func onButtonAction(_ sender: UIButton) {
         self.gameScene?.removeAllChildren()
        let controller = self.storyboard?.instantiateViewController(withIdentifier: String(describing: type(of: ViewController())))
            as! ViewController
        self.present(controller, animated: true, completion: {
            print("present")
        })
       
      
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}

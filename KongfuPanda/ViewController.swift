//
//  ViewController.swift
//  KongfuPanda
//
//  Created by wjc on 2019/6/17.
//  Copyright © 2019年 jackie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let userD = UserDefaults.standard
    @IBOutlet weak var pl: UILabel! //疲劳值
    @IBOutlet weak var heightScore: UILabel! //最高分
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.userD.set(5, forKey: "pl")//设置今天疲劳值
        
        pl.numberOfLines = 0
        var screen = UIScreen.main
        
        //背景图
        //创建一个用于显示背景图片的imageView
       let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "welcome03.png")
        backgroundImage.contentMode = .scaleAspectFill //等比缩放填充（图片可能有部分显示不全）
        //将背景图片imageView插入到当前视图中
        self.view.insertSubview(backgroundImage, at: 0)
        //
        //疲劳
        pl.text = self.getPL() < 0 ? "疲劳值:0"  : "疲劳值:\(self.getPL())"
        pl.frame = CGRect(x:screen.bounds.size.width/2/5, y:screen.bounds.size.height/2+50,width:150,height:100)
        //开始
        let button = UIButton(frame:CGRect(x:screen.bounds.size.width/2, y:screen.bounds.size.height/2-50, width:150, height:100))
        button.setTitle("开始", for:.normal) //普通状态下的文字
        button.setTitleColor(UIColor.red, for: .normal) //普通状态下文字的颜色
        button.addTarget(self, action: Selector("onButtonAction:"), for: .touchUpInside)
        //最高记录
        heightScore.frame = CGRect(x:screen.bounds.size.width/2/5, y:screen.bounds.size.height/2-50,width:150,height:100)
        heightScore.text = "最高记录:\(self.getScore())"
        //游戏说明
//        let btn = UIButton(frame:CGRect(x:screen.bounds.size.width/2, y:screen.bounds.size.height/2+50, width:150, height:100))
//        btn.setTitle("游戏说明", for:.normal) //普通状态下的文字
//        btn.setTitleColor(UIColor.red, for: .normal) //普通状态下文字的颜色
//        btn.addTarget(self, action: Selector("click:"), for: .touchUpInside)
//        self.view.addSubview(btn)
        self.view.addSubview(heightScore)
        self.view.addSubview(button)
        self.view.addSubview(pl)
       //
        print(self.getScore())
       
    }
     //开始按钮
    func onButtonAction(_ sender: UIButton) {
        if(self.getPL() > 0){
            self.jspl()
            let controller = self.storyboard?.instantiateViewController(withIdentifier: String(describing: type(of: GameViewController())))
                as! GameViewController
            self.present(controller, animated: true, completion: {
                print("present")
            })
        }else{
            pl.highlightedTextColor = UIColor.red
            pl.text = "疲劳值已用完明天见"
        }
        
        
    }
    //游戏说明
    func click(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: String(describing: type(of: game())))
            as! game
        self.present(controller, animated: true, completion: {
            print("present")
        })
    
        
    }
  //分数
    func getScore() -> Int {
       let score =  self.userD.integer(forKey: "score")
       
        return score
    }
    
    //疲劳设置
    func getPL() -> Int {
        
        let date = NSDate()
        
        let timeFormatter = DateFormatter()
        
        timeFormatter.dateFormat = "yyyyMMdd"
        
        let NowTime = timeFormatter.string(from: date as Date) as String //现在手机时间
        
        
        let today =  self.userD.string(forKey: "NowTime")
        print(NowTime)
        
        //如果第一次运行  或  第二天运行  重置疲劳
        if(today == nil || today != NowTime){
            self.userD.set(NowTime, forKey: "NowTime")
            self.userD.set(10, forKey: "pl")//设置今天疲劳值
            
        }else{
            //如果是同一天运行 则把PLIST里面返回出去
              self.userD.integer(forKey: "pl")

        }
        return self.userD.integer(forKey: "pl")

    }

    
    
    //游戏开始疲劳-1
    func jspl() {
        
        let currentPL =  self.userD.integer(forKey: "pl")
         self.userD.set(currentPL - 1, forKey: "pl")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
 
}


//
//  ViewController.swift
//  KongfuPanda
//
//  Created by wjc on 2019/6/17.
//  Copyright © 2019年 jackie. All rights reserved.
//

import UIKit

class game: UIViewController {
    let userD = UserDefaults.standard
    @IBOutlet weak var pl: UILabel! //疲劳值
    @IBOutlet weak var heightScore: UILabel! //最高分
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}


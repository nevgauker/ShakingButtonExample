//
//  ViewController.swift
//  Test
//
//  Created by rotem nevgauker on 3/18/18.
//  Copyright © 2018 rotem nevgauker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = ShakingButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        btn.center = self.view.center
        self.view.addSubview(btn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


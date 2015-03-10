//
//  ViewController.swift
//  HelloWorld
//
//  Created by Sqor Admin on 3/10/15.
//  Copyright (c) 2015 Sqor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func helloClicked(sender: UIButton) {
        sender.setTitle( "Yo", forState:  UIControlState.Normal)
    }
    
    

}


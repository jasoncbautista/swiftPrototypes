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
    
    
    
    var currentCount: Int = 0 {
        didSet {
            
            
            println("updated \(currentCount)")
            
            updateLilButton()
        }
    }

    @IBOutlet weak var lilButton: UIButton!
    @IBAction func helloClicked(sender: UIButton) {
        currentCount++
    }

    
    private func updateLilButton(){
          lilButton.setTitle( "Yo \(currentCount)", forState:  UIControlState.Normal)
    }
    

}


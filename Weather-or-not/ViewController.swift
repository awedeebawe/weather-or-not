//
//  ViewController.swift
//  Weather-or-not
//
//  Created by Lyubomir Marinov on 9.11.17.
//  Copyright © 2017 Lyubomir Marinov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let csvfile = Bundle.main.path(forResource: "demo", ofType: "csv") else { return }
        do {
            let csvpath = URL(fileURLWithPath: csvfile)
            let csvdata = try Data(contentsOf: csvpath)
            
            let csvstring = String(data: csvdata, encoding: .utf8) ?? ""
            
            print(csvstring)
        } catch {
            print("awedeebawe")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


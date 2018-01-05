//
//  ViewController.swift
//  CookieSample
//
//  Created by kazuki229 on 2018/01/05.
//  Copyright © 2018年 kazuki229. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    @IBOutlet weak var uiWebViewButton: UIButton!
    @IBOutlet weak var wkWebViewButton: UIButton!
    @IBOutlet weak var sfSafariViewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showSFSafariView(_ sender: UIButton) {
        let vc = SFSafariViewController(url: URL(string: Const.googleUrl)!)
        present(vc, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


//
//  SFAuthenticationSessionViewController.swift
//  CookieSample
//
//  Created by kazuki229 on 2018/01/06.
//  Copyright © 2018年 kazuki229. All rights reserved.
//

import UIKit
import SafariServices

@available(iOS 11.0, *)
class SFAuthenticationSessionViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    var authSession: SFAuthenticationSession!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://google.co.jp")!
        self.authSession = SFAuthenticationSession(url: url, callbackURLScheme: "scheme") { (url, error) in

        }
    }
    
    @IBAction func start(_ sender: UIButton) {
        self.authSession.start()
    }
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

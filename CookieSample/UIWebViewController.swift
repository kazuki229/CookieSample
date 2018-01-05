//
//  UIWebViewController.swift
//  CookieSample
//
//  Created by 都筑一希 on 2018/01/05.
//  Copyright © 2018年 kazuki229. All rights reserved.
//

import UIKit

class UIWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = URLRequest(url: URL(string: Const.googleUrl)!)
        webView.loadRequest(request)
    }
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

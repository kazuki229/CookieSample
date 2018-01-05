//
//  WKWebViewController.swift
//  CookieSample
//
//  Created by kazuki229 on 2018/01/05.
//  Copyright © 2018年 kazuki229. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController {

    var webView: WKWebView!
    var timer: Timer!
    
    @IBOutlet weak var cookieLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = URLRequest(url: URL(string: Const.googleUrl)!)
        let conf = WKWebViewConfiguration()
        self.webView = WKWebView(frame: self.view.frame, configuration: conf)
        self.view.addSubview(self.webView)
        self.webView.load(request)
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        self.timer.fire()
    }
    
    override func viewDidLayoutSubviews() {
        self.webView.frame.size.height = self.view.frame.size.height - 100
    }
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func update(tm: Timer) {
        self.updateUIStorageLabel()
    }
    
    func updateUIStorageLabel() {
        let cookieStorage = HTTPCookieStorage.shared
        if let cookies = cookieStorage.cookies {
            for cookie in cookies {
                if cookie.name == "SID" {
                    self.cookieLabel.text = cookie.value
                    break
                }
                if cookies.last == cookie {
                    self.cookieLabel.text = "empty"
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

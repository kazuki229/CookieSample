//
//  WKWebViewController.swift
//  CookieSample
//
//  Created by kazuki229 on 2018/01/05.
//  Copyright © 2018年 kazuki229. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController, WKHTTPCookieStoreObserver {

    var webView: WKWebView!
    
    @IBOutlet weak var cookieLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = URLRequest(url: URL(string: Const.googleUrl)!)
        let conf = WKWebViewConfiguration()
        
        if #available(iOS 11.0, *) {
            conf.websiteDataStore.httpCookieStore.add(self)
        }
        self.webView = WKWebView(frame: self.view.frame, configuration: conf)
        self.view.addSubview(self.webView)
        self.webView.load(request)
    }
    
    @available(iOS 11.0, *)
    func cookiesDidChange(in cookieStore: WKHTTPCookieStore) {
        cookieStore.getAllCookies({ [weak self] (cookies) in
            for cookie in cookies {
                if cookie.name == "SID" {
                    if let weakself = self {
                        weakself.cookieLabel.text = cookie.value
                    }
                    break
                }
                if cookies.last == cookie {
                    if let weakself = self {
                        weakself.cookieLabel.text = "empty"
                    }
                }
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        self.webView.frame.size.height = self.view.frame.size.height - 100
    }
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

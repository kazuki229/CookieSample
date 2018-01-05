//
//  UIWebViewController.swift
//  CookieSample
//
//  Created by kazuki229 on 2018/01/05.
//  Copyright © 2018年 kazuki229. All rights reserved.
//

import UIKit
import WebKit

class SyncTestViewController: UIViewController {
    var wkWebView: WKWebView!
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var prevWK: UIButton!
    @IBOutlet weak var nextWK: UIButton!
    @IBOutlet weak var refreshWK: UIButton!
    @IBOutlet weak var prevUI: UIButton!
    @IBOutlet weak var nextUI: UIButton!
    @IBOutlet weak var refreshUI: UIButton!
    
    @IBOutlet weak var wkjsLabel: UILabel!
    @IBOutlet weak var wkStorageLabel: UILabel!
    @IBOutlet weak var uijsLabel: UILabel!
    @IBOutlet weak var uiStorageLabel: UILabel!
    
    var timer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        let request = URLRequest(url: URL(string: Const.googleUrl)!)
        self.webView.loadRequest(request)
        let conf = WKWebViewConfiguration()
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width/2, height: self.view.frame.size.height/2)
        self.wkWebView = WKWebView(frame: frame, configuration: conf)
        self.view.addSubview(self.wkWebView)
        let wkrequest = URLRequest(url: URL(string: Const.googleUrl)!)
        self.wkWebView.load(wkrequest)
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        self.timer.fire()
    }
    
   override func viewDidLayoutSubviews() {
        self.wkWebView.frame.size = self.webView.frame.size
        self.wkWebView.frame.origin.y = self.webView.frame.origin.y
    }
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func prev(_ sender: UIButton) {
        if sender.tag == 0 && self.wkWebView.canGoBack {
            self.wkWebView.goBack()
        } else if sender.tag == 1 && self.webView.canGoBack {
            self.webView.goBack()
        }
    }
    
    @IBAction func next(_ sender: UIButton) {
        if sender.tag == 0 && self.wkWebView.canGoForward {
            self.wkWebView.goForward()
        } else if sender.tag == 1 && self.webView.canGoForward {
            self.webView.goForward()
        }
    }
    
    @IBAction func refresh(_ sender: UIButton) {
        if sender.tag == 0 {
            self.wkWebView.reload()
        } else {
            self.webView.reload()
        }
    }
    
    @objc func update(tm: Timer)
    {
        self.updateUIStorageLabel()
        if #available(iOS 11.0, *) {
            self.updateWKStorageLabel()
        }
        self.updateWKJSLabel()
        self.updateUIJSLabel()
    }
    
    func updateUIStorageLabel() {
        let cookieStorage = HTTPCookieStorage.shared
        if let cookies = cookieStorage.cookies {
            for cookie in cookies {
                if cookie.name == "SID" {
                    self.uiStorageLabel.text = cookie.value
                    break
                }
                if cookies.last == cookie {
                    self.uiStorageLabel.text = "empty"
                }
            }
        }
    }
    
    @available(iOS 11.0, *)
    func updateWKStorageLabel() {
        let cookieStore = self.wkWebView.configuration.websiteDataStore.httpCookieStore
        cookieStore.getAllCookies { (cookies) in
            for cookie in cookies {
                if cookie.name == "SID" {
                    self.wkStorageLabel.text = cookie.value
                    break
                }
                if cookies.last == cookie {
                    self.wkStorageLabel.text = "empty"
                }
            }
        }
    }
    
    func updateWKJSLabel() {
        self.wkWebView.evaluateJavaScript("document.cookie") { [weak self] (result, error) in
            if let weakself = self {
                weakself.wkjsLabel.text =  weakself.getSIDFromCookieString(cookieString: result as! String)
            }
        }
    }
    
    func updateUIJSLabel() {
        if let str = self.webView.stringByEvaluatingJavaScript(from: "document.cookie") {
            self.uijsLabel.text = self.getSIDFromCookieString(cookieString: str)
            return
        }
        self.uijsLabel.text = "empty"
    }

    func getSIDFromCookieString(cookieString: String) -> String {
        let cookies = cookieString.components(separatedBy: "; ")
        for cookie in cookies {
            let value = cookie.components(separatedBy: "=")
            if value[0] == "SID" {
                return value[1] as String
            }
        }
        return "empty"
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

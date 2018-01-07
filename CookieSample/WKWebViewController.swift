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
    @IBOutlet weak var setCookieButton: UIButton!
    @IBOutlet weak var deleteCookieButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = URLRequest(url: URL(string: Const.googleUrl)!)
        let conf = WKWebViewConfiguration()
        
        self.webView = WKWebView(frame: self.view.frame, configuration: conf)
        if #available(iOS 11.0, *) {
            self.webView.configuration.websiteDataStore.httpCookieStore.add(self)
        }
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
        self.webView.frame.size.height = self.view.frame.size.height - 150
    }
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setCookie(_ sender: UIButton) {
        if #available(iOS 11.0, *) {
            let cookieStore = self.webView.configuration.websiteDataStore.httpCookieStore
            let cookieProperty: [HTTPCookiePropertyKey: Any] = [
                HTTPCookiePropertyKey.domain: ".google.co.jp",
                HTTPCookiePropertyKey.path: "/",
                HTTPCookiePropertyKey.name: "SID",
                HTTPCookiePropertyKey.value: "hogehoge",
                HTTPCookiePropertyKey.secure: "FALSE",
                HTTPCookiePropertyKey.expires: Date()
            ]
            let cookie = HTTPCookie(properties: cookieProperty)!
            cookieStore.setCookie(cookie, completionHandler: {
                
            })
        }
    }
    
    @IBAction func deleteCookie(_ sender: UIButton) {
        if #available(iOS 11.0, *) {
            let cookieStore = self.webView.configuration.websiteDataStore.httpCookieStore
            cookieStore.getAllCookies({ (cookies) in
                for cookie in cookies where cookie.value == "SID" {
                    cookieStore.delete(cookie, completionHandler: {
                    })
                }
            })
        }
    }
    
    deinit {
        if #available(iOS 11.0, *) {
            self.webView.configuration.websiteDataStore.httpCookieStore.remove(self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//
//  HTTPCookieStorageViewController.swift
//  CookieSample
//
//  Created by kazuki229 on 2018/01/06.
//  Copyright © 2018年 kazuki229. All rights reserved.
//

import UIKit
import WebKit

class HTTPCookieStorageViewController: UIViewController {
    var webView: WKWebView!

    @IBOutlet weak var sidLabel: UILabel!
    @IBOutlet weak var ssidLabel: UILabel!
    
    var timer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = URLRequest(url: URL(string: Const.googleUrl)!)
        let conf = WKWebViewConfiguration()
        let cookieStorage = HTTPCookieStorage.shared
        cookieStorage.cookieAcceptPolicy = .always

        self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0),
                                 configuration: conf)
        self.view.addSubview(self.webView)
        self.webView.load(request)

        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.sidLabel.translatesAutoresizingMaskIntoConstraints = false
        self.ssidLabel.translatesAutoresizingMaskIntoConstraints = false

        self.webView.topAnchor.constraint(equalTo: self.topLayoutGuide.topAnchor).isActive = true
        self.webView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.webView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.webView.bottomAnchor.constraint(equalTo: self.sidLabel.topAnchor).isActive = true
        self.webView.bottomAnchor.constraint(equalTo: self.ssidLabel.topAnchor).isActive = true

        self.timer = Timer.scheduledTimer(timeInterval: 0.1,
                                          target: self,
                                          selector: #selector(self.update),
                                          userInfo: nil,
                                          repeats: true)
        self.timer.fire()
    }

    @IBAction func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteCookie(_ sender: UIButton) {
        let cookieStorage = HTTPCookieStorage.shared
        if let cookies = cookieStorage.cookies {
            for cookie in cookies {
                if cookie.name == "SID" || cookie.name == "SSID" {
                    cookieStorage.deleteCookie(cookie)
                }
            }
        }
    }
    
    @IBAction func setCookie(_ sender: UIButton) {
        let cookieStorage = HTTPCookieStorage.shared
        let cookieProperty: [HTTPCookiePropertyKey: Any] = [
            HTTPCookiePropertyKey.domain: ".google.co.jp",
            HTTPCookiePropertyKey.path: "/",
            HTTPCookiePropertyKey.name: "SID",
            HTTPCookiePropertyKey.value: "hogehoge",
            HTTPCookiePropertyKey.secure: "FALSE",
            HTTPCookiePropertyKey.expires: Date(timeIntervalSinceNow: 10)
        ]
        let cookie = HTTPCookie(properties: cookieProperty)!
        cookieStorage.setCookie(cookie)
        
        let cookieProperty2: [HTTPCookiePropertyKey: Any] = [
            HTTPCookiePropertyKey.domain: ".google.co.jp",
            HTTPCookiePropertyKey.path: "/",
            HTTPCookiePropertyKey.name: "SSID",
            HTTPCookiePropertyKey.value: "hogehoge",
            HTTPCookiePropertyKey.secure: "true",
            HTTPCookiePropertyKey.expires: Date(timeIntervalSinceNow: 10)
        ]
        let cookie2 = HTTPCookie(properties: cookieProperty2)!
        cookieStorage.setCookie(cookie2)
    }
    
    @IBAction func removeCookies() {
        let cookieStorage = HTTPCookieStorage.shared
        cookieStorage.removeCookies(since: Date(timeIntervalSinceNow: -100))
    }

    @IBAction func reload(_ sender: UIBarButtonItem) {
        self.webView.reload()
    }
    @IBAction func next(_ sender: UIBarButtonItem) {
        if self.webView.canGoForward {
            self.webView.goForward()
        }
    }
    @IBAction func prev(_ sender: UIBarButtonItem) {
        if self.webView.canGoBack {
            self.webView.goBack()
        }
    }
    
    @objc func update() {
        let cookieStorage = HTTPCookieStorage.shared
        if let cookies = cookieStorage.cookies {
            var sidflg = false, ssidflg = false
            for cookie in cookies {
                if cookie.name == "SID" {
                    sidflg = true
                    self.sidLabel.text =
                        "name: SID\nvalue: " + cookie.value.prefix(6) +
                        "\nhttponly: "       + String(cookie.isHTTPOnly)
                    self.sidLabel.sizeToFit()
                    continue
                }
                
                if cookie.name == "SSID" {
                    ssidflg = true
                    self.ssidLabel.text =
                        "name: SSID\nvalue: " + cookie.value.prefix(6) +
                        "\nhttponly: " + String(cookie.isHTTPOnly)
                    self.ssidLabel.sizeToFit()
                    continue
                }
                
                if cookies.last == cookie {
                    if !sidflg {
                        self.sidLabel.text = "empty"
                    }
                    if !ssidflg {
                        self.ssidLabel.text = "empty"
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

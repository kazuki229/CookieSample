//
//  WKHTTPCookieStoreViewController.swift
//  CookieSample
//
//  Created by kazuki229 on 2018/01/07.
//  Copyright © 2018年 kazuki229. All rights reserved.
//

import UIKit
import WebKit

class WKHTTPCookieStoreViewController: UIViewController, WKHTTPCookieStoreObserver {
    var webView: WKWebView!

    @IBOutlet weak var sidLabel: UILabel!
    @IBOutlet weak var ssidLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let request = URLRequest(url: URL(string: Const.googleUrl)!)
        let conf = WKWebViewConfiguration()
        let cookieStorage = HTTPCookieStorage.shared
        cookieStorage.cookieAcceptPolicy = .always

        self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0),
                                 configuration: conf)
        if #available(iOS 11.0, *) {
            self.webView.configuration.websiteDataStore.httpCookieStore.add(self)
        }
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
    }

    @IBAction func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func prev(_ sender: UIBarButtonItem) {
        if self.webView.canGoBack {
            self.webView.goBack()
        }
    }

    @IBAction func next(_ sender: UIBarButtonItem) {
        if self.webView.canGoForward {
            self.webView.goForward()
        }
    }

    @IBAction func refresh(_ sender: UIBarButtonItem) {
        self.webView.reload()
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
                HTTPCookiePropertyKey.expires: Date(timeIntervalSinceNow: 10)
            ]
            let cookie = HTTPCookie(properties: cookieProperty)!
            cookieStore.setCookie(cookie, completionHandler: nil)

            let cookieProperty2: [HTTPCookiePropertyKey: Any] = [
                HTTPCookiePropertyKey.domain: ".google.co.jp",
                HTTPCookiePropertyKey.path: "/",
                HTTPCookiePropertyKey.name: "SSID",
                HTTPCookiePropertyKey.value: "hogehoge",
                HTTPCookiePropertyKey.secure: "true",
                HTTPCookiePropertyKey.expires: Date(timeIntervalSinceNow: 10)
            ]
            let cookie2 = HTTPCookie(properties: cookieProperty2)!
            cookieStore.setCookie(cookie2, completionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
    }

    @IBAction func deleteCookie(_ sender: UIButton) {
        if #available(iOS 11.0, *) {
            let cookieStore = self.webView.configuration.websiteDataStore.httpCookieStore
            cookieStore.getAllCookies({ (cookies) in
                for cookie in cookies {
                    cookieStore.delete(cookie, completionHandler: nil)
                }
            })
        } else {
            // Fallback on earlier versions
        }
    }

    @available(iOS 11.0, *)
    func cookiesDidChange(in cookieStore: WKHTTPCookieStore) {
        cookieStore.getAllCookies({ [weak self] (cookies) in
            var sidflg = false, ssidflg = false
            for cookie in cookies {
                if cookie.name == "SID" {
                    sidflg = true
                    if let weakself = self {
                        weakself.sidLabel.text =
                            "name: SID\nvalue: " + cookie.value.prefix(6) +
                            "\nhttponly: " + String(cookie.isHTTPOnly)
                        weakself.sidLabel.sizeToFit()
                    }
                    continue
                }

                if cookie.name == "SSID" {
                    ssidflg = true
                    if let weakself = self {
                        weakself.ssidLabel.text =
                            "name: SSID\nvalue: " + cookie.value.prefix(6) +
                            "\n" + "httponly: " + String(cookie.isHTTPOnly)
                        weakself.ssidLabel.sizeToFit()
                    }
                    continue
                }

                if cookies.last == cookie {
                    if let weakself = self {
                        if !sidflg {
                            weakself.sidLabel.text = "empty"
                        }
                        if !ssidflg {
                            weakself.ssidLabel.text = "empty"
                        }
                    }
                }
            }
        })
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

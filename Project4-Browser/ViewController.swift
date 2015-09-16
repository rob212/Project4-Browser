//
//  ViewController.swift
//  Project4-Browser
//
//  Created by Robert McBryde on 16/09/2015.
//  Copyright © 2015 Robert McBryde. All rights reserved.
//

import UIKit
import WebKit


class ViewController: UIViewController, WKNavigationDelegate {
    var webView : WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self;
        view = webView
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: "https://www.hackingwithswift.com")!
        webView.loadRequest(NSURLRequest(URL: url))
        webView.allowsBackForwardNavigationGestures = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


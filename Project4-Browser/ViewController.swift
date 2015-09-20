//
//  ViewController.swift
//  Project4-Browser
//
//  Created by Robert McBryde on 16/09/2015.
//  Copyright © 2015 Robert McBryde. All rights reserved.
//

import UIKit
import WebKit

// todo - add pragma marks to clean up code and add UIAlertView to inform user why they cannot click links taking them out of whitelisted sites and potential UITableView 
// with a list of all initial sites that can be visited. 

class ViewController: UIViewController, WKNavigationDelegate {
    var webView : WKWebView!
    var progressView : UIProgressView!
    var websites = ["apple.com", "microsoft.com", "hackingwithswift.com"]
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self;
        view = webView
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        openPage(websites[2])
        webView.allowsBackForwardNavigationGestures = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: UIBarButtonItemStyle.Plain, target: self, action: "openTapped")
        
        progressView = UIProgressView(progressViewStyle: .Default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .Refresh, target: webView, action: "reload")
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.New, context: nil)
        
        toolbarItems = [progressButton, spacer, refresh]
        navigationController?.toolbarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openTapped() {
        let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .ActionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: UIAlertActionStyle.Default, handler: openPageFromAction))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func openPageFromAction(action: UIAlertAction!) {
        openPage(action.title!)
    }
    
    func openPage(page: String) {
        if let url = NSURL(string: "https://" + page) {
            webView.loadRequest(NSURLRequest(URL: url))
        }
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath! == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.URL {
            
            if let host = url.host {
                for website in websites {
                    if host.rangeOfString(website) != nil {
                        decisionHandler(.Allow)
                        return
                    }
                }
            }
        }
        decisionHandler(.Cancel)
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
}


//
//  WebsiteViewController.swift
//  Community Balance
//
//  Created by Anant Jain on 12/28/14.
//  Copyright (c) 2014 Anant Jain. All rights reserved.
//

import UIKit
import WebKit

class WebsiteViewController: UIViewController, WKNavigationDelegate, PagesTableViewControllerDelegate {
    
    @IBOutlet weak var website: WKWebView!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        if website.canGoBack {
            website.goBack()
            updateButtons()
        }
    }
    
    @IBAction func goForward(_ sender: UIBarButtonItem) {
        if website.canGoForward {
            website.goForward()
            updateButtons()
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        UIView.transition(with: progressBar, duration: 0.2, options: .transitionCrossDissolve, animations: { () -> Void in
            self.progressBar.isHidden = false
            }, completion: nil)
        updateButtons()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        progressBar.setProgress(1.0, animated: true)
        
        perform(#selector(animateOutProgress), with: nil, afterDelay: 0.3)
        
        updateButtons()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        UIView.transition(with: progressBar, duration: 0.2, options: .transitionCrossDissolve, animations: { () -> Void in
            self.progressBar.isHidden = true
            }, completion: nil)
        updateButtons()
    }
    
    @objc func animateOutProgress() {
        UIView.transition(with: progressBar, duration: 0.2, options: .transitionCrossDissolve, animations: { () -> Void in
            self.progressBar.isHidden = true
            }, completion: { (completed) -> Void in
                self.progressBar.progress = 0
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Configurs website
        website.navigationDelegate = self
        website.load(URLRequest(url: URL(string: "http://www.youtube.com/user/CommBAL/")!))
        website.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if let site = object as? WKWebView {
                if site == website {
                    progressBar.setProgress(Float(website.estimatedProgress), animated: true)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateButtons() {
        backButton.isEnabled = website.canGoBack
        forwardButton.isEnabled = website.canGoForward
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Pages" {
            let pagesVC = (segue.destination as! UINavigationController).topViewController as! PagesTableViewController
            pagesVC.delegate = self
        }
    }
    
    func loadWebsite(_ websiteURL: URLRequest) {
        self.website.load(websiteURL)
    }

}

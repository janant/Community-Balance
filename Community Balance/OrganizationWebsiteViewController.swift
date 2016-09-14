//
//  OrganizationWebsiteViewController.swift
//  Community Balance
//
//  Created by Anant Jain on 12/29/14.
//  Copyright (c) 2014 Anant Jain. All rights reserved.
//

import UIKit
import WebKit

protocol OrganizationWebsiteViewControllerDelegate {
    func dismissedWebsite()
}

class OrganizationWebsiteViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    
    var progressBar = UIProgressView(progressViewStyle: UIProgressViewStyle.bar)
    
    var website = WKWebView()
    
    var delegate: OrganizationWebsiteViewControllerDelegate?
    
    var websiteURLRequest: URLRequest?
    
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
        UIApplication.shared().isNetworkActivityIndicatorVisible = true
        UIView.transition(with: progressBar, duration: 0.2, options: .transitionCrossDissolve, animations: { () -> Void in
            self.progressBar.isHidden = false
            }, completion: nil)
        updateButtons()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared().isNetworkActivityIndicatorVisible = false
        
        progressBar.setProgress(1.0, animated: true)
        
        perform("animateOutProgress", with: nil, afterDelay: 0.3)
        
        updateButtons()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        UIApplication.shared().isNetworkActivityIndicatorVisible = false
        UIView.transition(with: progressBar, duration: 0.2, options: .transitionCrossDissolve, animations: { () -> Void in
            self.progressBar.isHidden = true
            }, completion: nil)
        updateButtons()
    }
    
    func animateOutProgress() {
        UIView.transition(with: progressBar, duration: 0.2, options: .transitionCrossDissolve, animations: { () -> Void in
            self.progressBar.isHidden = true
            }, completion: { (completed) -> Void in
                self.progressBar.progress = 0
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        website.load(websiteURLRequest!)
        website.navigationDelegate = self
        website.allowsBackForwardNavigationGestures = true
        view = website
        
        let leading = NSLayoutConstraint(item: progressBar, attribute: .leading, relatedBy: .equal, toItem: website, attribute: .leading, multiplier: 1.0, constant: 0)
        let trailing = NSLayoutConstraint(item: progressBar, attribute: .trailing, relatedBy: .equal, toItem: website, attribute: .trailing, multiplier: 1.0, constant: 0)
        let top = NSLayoutConstraint(item: progressBar, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(progressBar)
        
        self.view.addConstraints([leading, trailing, top])
        
        website.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        website.backgroundColor = UIColor.white()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: AnyObject?, change: [NSKeyValueChangeKey : AnyObject]?, context: UnsafeMutablePointer<Void>?) {
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
    
    @IBAction func shareWebsite(_ sender: AnyObject) {
        guard let shareURL = websiteURLRequest?.url else {
            return
        }
        let shareSheet = UIActivityViewController(activityItems: [shareURL], applicationActivities: nil)
        shareSheet.modalPresentationStyle = .popover
        shareSheet.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        present(shareSheet, animated: true, completion: nil)
    }
    
    func updateButtons() {
        backButton.isEnabled = website.canGoBack
        forwardButton.isEnabled = website.canGoForward
    }

    @IBAction func closeWebsite(_ sender: AnyObject) {
        website.removeObserver(self, forKeyPath: "estimatedProgress")
        UIApplication.shared().isNetworkActivityIndicatorVisible = false
        dismiss(animated: true, completion: { () -> Void in
            if self.delegate != nil {
                self.delegate?.dismissedWebsite()
            }
        })
    }

}

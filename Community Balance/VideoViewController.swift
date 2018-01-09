//
//  VideoViewController.swift
//  Community Balance
//
//  Created by Anant Jain on 12/29/14.
//  Copyright (c) 2014 Anant Jain. All rights reserved.
//

import UIKit
import WebKit

protocol VideoViewControllerDelegate {
    func closedVideo()
}

class VideoViewController: UIViewController {
    
    @IBOutlet weak var video: WKWebView!
    
    var videoHTMLString: String?
    var navigationTitle: String?
    
    var delegate: VideoViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = navigationTitle!
        video.loadHTMLString(videoHTMLString!, baseURL: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reloadVideo(_ sender: AnyObject) {
        video.loadHTMLString(videoHTMLString!, baseURL: nil)
    }

    @IBAction func closeVideo(_ sender: AnyObject) {
        dismiss(animated: true) {
            self.delegate?.closedVideo()
        }
    }
}

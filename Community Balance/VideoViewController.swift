//
//  VideoViewController.swift
//  Community Balance
//
//  Created by Anant Jain on 12/29/14.
//  Copyright (c) 2014 Anant Jain. All rights reserved.
//

import UIKit

protocol VideoViewControllerDelegate {
    func closedVideo()
}

class VideoViewController: UIViewController {
    
    @IBOutlet weak var video: UIWebView!
    
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
        dismiss(animated: true, completion: { () -> Void in
            if self.delegate != nil {
                self.delegate?.closedVideo()
            }
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

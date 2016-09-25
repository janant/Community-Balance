//
//  PagesTableViewController.swift
//  Community Balance
//
//  Created by Anant Jain on 12/28/14.
//  Copyright (c) 2014 Anant Jain. All rights reserved.
//

import UIKit

protocol PagesTableViewControllerDelegate {
    func loadWebsite(_ websiteURL: URLRequest)
}

class PagesTableViewController: UITableViewController {
    
    var delegate: PagesTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBackToWebsite(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var websiteURL: String?
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            websiteURL = "https://dl.dropboxusercontent.com/u/55399127/communitybalance.net/Home.html"
        case 1:
            websiteURL = "http://www.youtube.com/user/CommBAL/"
        case 2:
            switch (indexPath as NSIndexPath).row {
            case 0:
                UIApplication.shared.openURL(URL(string: "https://dl.dropboxusercontent.com/u/55399127/communitybalance.net/Home.html")!)
            case 1:
                UIApplication.shared.openURL(URL(string: "http://www.youtube.com/user/CommBAL/")!)
            default:
                return
            }
        default:
            return
        }
        
        if let address = websiteURL {
            self.delegate?.loadWebsite(URLRequest(url: URL(string: address)!))
            dismiss(animated: true, completion: nil)
        }
        else {
            self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated: true)
        }
    }
}

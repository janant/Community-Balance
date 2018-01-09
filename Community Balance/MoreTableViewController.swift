//
//  MoreTableViewController.swift
//  Community Balance
//
//  Created by Anant Jain on 12/28/14.
//  Copyright (c) 2014 Anant Jain. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Deselects table row if necessary
        if splitViewController?.traitCollection.horizontalSizeClass == .compact {
            if let selectedIndex = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndex, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.splitViewController?.preferredDisplayMode = .allVisible
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).section {
        case 0:
            performSegue(withIdentifier: "Show Detail", sender: indexPath)
        case 1:
            switch (indexPath as NSIndexPath).row {
            case 0:
                UIApplication.shared.open(URL(string: "http://www.communitybalance.net/")!, options: [String : Any](), completionHandler: nil)
            case 1:
                UIApplication.shared.open(URL(string: "http://www.youtube.com/user/CommBAL/")!, options: [String : Any](), completionHandler: nil)
            default:
                break
            }
            self.tableView.deselectRow(at: indexPath, animated: false)
        default:
            break
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Detail" {
            let moreDetailVC = (segue.destination as! UINavigationController).topViewController as! MoreDetailViewController
            
            switch ((sender as! IndexPath) as NSIndexPath).row {
            case 0:
                moreDetailVC.infoType = .aboutShow
            case 1:
                moreDetailVC.infoType = .aboutApp
            default:
                break
            }
            
            moreDetailVC.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            moreDetailVC.navigationItem.leftItemsSupplementBackButton = true
        }
    }
}

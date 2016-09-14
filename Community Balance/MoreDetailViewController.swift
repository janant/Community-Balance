//
//  MoreDetailViewController.swift
//  Community Balance
//
//  Created by Anant Jain on 12/28/14.
//  Copyright (c) 2014 Anant Jain. All rights reserved.
//

import UIKit

enum MoreDetailViewControllerInfo {
    case aboutNone
    case aboutShow
    case aboutApp
}

class MoreDetailViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var selectTopicView: UIView!
    @IBOutlet weak var detailTableView: UITableView!
    
    var infoType: MoreDetailViewControllerInfo = .aboutNone
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        selectTopicView.isHidden = infoType != .aboutNone
        detailTableView.isHidden = infoType == .aboutNone
        
        switch infoType {
        case .aboutShow:
            self.navigationItem.title = "About Community Balance"
        case .aboutApp:
            self.navigationItem.title = "About the App"
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        switch infoType {
        case .aboutNone:
            return 0
        case .aboutShow:
            return 3
        case .aboutApp:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        switch infoType {
        case .aboutNone:
            return 0
        case .aboutShow:
            switch section {
            case 0:
                return 0
            case 1:
                return 2
            case 2:
                return 2
            default:
                return 0
            }
        case .aboutApp:
            switch section {
            case 0:
                return 1
            case 1:
                return 5
            default:
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch infoType {
        case .aboutShow:
            switch section {
            case 1:
                return "Current Crew"
            case 2:
                return "Former Crew"
            default:
                return nil
            }
        case .aboutApp:
            switch section {
            case 0:
                return "App Information"
            case 1:
                return "App Creators"
            default:
                return nil
            }
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch infoType {
        case .aboutShow:
            switch section {
            case 0:
                return "Community Balance is a television show on KMVT 15 that promotes community service in our society."
            case 2:
                return "Community Balance is filmed at KMVT 15 Studios in Mountain View, California.  The show airs on three television channels throughout the Bay Area and Central Valley of California to a viewing audience of millions of viewers and can be viewed worldwide by using a Roku digital streaming device or through YouTube.\n\nTo view show listings, visit the Watch page on our website."
            default:
                return nil
            }
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell
        
        switch infoType {
        case .aboutShow:
            switch (indexPath as NSIndexPath).section {
            case 1:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    cell.textLabel!.text = "Producer"
                    cell.detailTextLabel!.text = "Alex Lo"
                case 1:
                    cell.textLabel!.text = "Associate Producer"
                    cell.detailTextLabel!.text = "Michael Pon"
                default:
                    break
                }
            case 2:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    cell.textLabel!.text = "Producer"
                    cell.detailTextLabel!.text = "Stephen Pon"
                case 1:
                    cell.textLabel!.text = "Producer"
                    cell.detailTextLabel!.text = "Marc Isaac Potter"
                default:
                    break
                }
            default:
                break
            }
        case .aboutApp:
            switch (indexPath as NSIndexPath).section {
            case 0:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    cell.textLabel!.text = "App Version"
                    cell.detailTextLabel!.text = Bundle.main().infoDictionary!["CFBundleShortVersionString"] as? String
                default:
                    break
                }
            case 1:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    cell.textLabel!.text = "Developer"
                    cell.detailTextLabel!.text = "Anant Jain"
                case 1:
                    cell.textLabel!.text = "Assistant Developer"
                    cell.detailTextLabel!.text = "Alex Lo"
                case 2:
                    cell.textLabel!.text = "UI Designer"
                    cell.detailTextLabel!.text = "Anant Jain"
                case 3:
                    cell.textLabel!.text = "Graphic Designer"
                    cell.detailTextLabel!.text = "Anant Jain"
                case 4:
                    cell.textLabel!.text = "Icon Designer"
                    cell.detailTextLabel!.text = "Anant Jain"
                default:
                    break
                }
            default:
                break
            }
        default:
            break
        }
        
        return cell
    }
    
}

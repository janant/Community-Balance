//
//  WatchViewController.swift
//  Community Balance
//
//  Created by Anant Jain on 12/28/14.
//  Copyright (c) 2014 Anant Jain. All rights reserved.
//

import UIKit

protocol WatchViewControllerDelegate {
    func updatedFavorites()
    func reloadedData()
}

class WatchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WatchDetailViewControllerDelegate {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadFailedView: UIView!
    @IBOutlet weak var episodesTable: UITableView!
    
    var refreshControl = UIRefreshControl()
    
    var initialLoadSucceeded = false
    var episodesData: [[String: AnyObject]]?
    var favoritesData: [[String: AnyObject]]?
    
    var delegate: WatchViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        if !initialLoadSucceeded {
            initialLoadSucceeded = true
            
            loadingIndicator.alpha = 1.0
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
            
            loadFailedView.alpha = 0.0
            loadFailedView.isHidden = true
            
            UIApplication.shared().isNetworkActivityIndicatorVisible = true
            
            let urlRequest = URLRequest(url: URL(string: "http://dl.dropboxusercontent.com/u/55399127/communitybalance.net/App_Property_List_files/Episodes.plist")!)
            
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: OperationQueue.main(), completionHandler: { (response, data, error) -> Void in
                UIApplication.shared().isNetworkActivityIndicatorVisible = false
                self.loadingIndicator.stopAnimating()
                
                if error == nil {
                    
                    do {
                        self.episodesData = try PropertyListSerialization.propertyList(from: data!, options: PropertyListSerialization.MutabilityOptions(), format: nil) as? [[String: AnyObject]]
                    } catch {
                        
                    }
                    
                    self.episodesTable.reloadData()
                    
                    self.episodesTable.isHidden = false
                    UIView.animate(withDuration: 0.25, animations: { () -> Void in
                        self.episodesTable.alpha = 1.0
                        self.loadFailedView.alpha = 0.0
                        self.loadingIndicator.alpha = 0.0
                        }, completion: { (completed: Bool) -> Void in
                            self.loadFailedView.isHidden = true
                            self.loadingIndicator.isHidden = true
                    })
                }
                else {
                    self.initialLoadSucceeded = false
                    
                    self.loadFailedView.isHidden = false
                    UIView.animate(withDuration: 0.25, animations: { () -> Void in
                        self.episodesTable.alpha = 0.0
                        self.loadFailedView.alpha = 1.0
                        self.loadingIndicator.alpha = 0.0
                        }, completion: { (completed: Bool) -> Void in
                            self.episodesTable.isHidden = true
                            self.loadingIndicator.isHidden = true
                    })
                }
            })
        }
        
        if let favorites = UserDefaults.standard().array(forKey: "Favorites") as? [[String: AnyObject]] {
            self.favoritesData = favorites
        }
        
        let selectedIndex = self.episodesTable.indexPathForSelectedRow
        
        self.episodesTable.reloadData()
        
        if selectedIndex != nil {
            self.episodesTable.selectRow(at: selectedIndex, animated: false, scrollPosition: .none)
            
            if self.splitViewController!.traitCollection.horizontalSizeClass == .compact {
                self.episodesTable.deselectRow(at: selectedIndex!, animated: true)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refreshControl.addTarget(self, action: Selector("refreshData"), for: UIControlEvents.valueChanged)
        self.episodesTable.addSubview(refreshControl)
        
//        let detailNavVC = self.splitViewController?.viewControllers[1] as! UINavigationController
//        detailNavVC.topViewController!.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
        
        self.splitViewController?.preferredDisplayMode = .allVisible
        self.splitViewController?.preferredPrimaryColumnWidthFraction = 0.5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if episodesData != nil {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if episodesData != nil {
            return episodesData!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Episode Cell")! as UITableViewCell
        
        let favoritesButton = cell.viewWithTag(1) as! UIButton
        let titleLabel = cell.viewWithTag(2) as! UILabel
        let descriptionLabel = cell.viewWithTag(3) as! UILabel
        
        titleLabel.text = episodesData![(indexPath as NSIndexPath).row]["Name"] as? String
        descriptionLabel.text = episodesData![(indexPath as NSIndexPath).row]["Description"] as? String
        
        var isFavorite = false
        
        if favoritesData != nil {
            for var favoriteIndex = 0; favoriteIndex < favoritesData?.count; favoriteIndex += 1 {
                let favorite = favoritesData![favoriteIndex]
                let episode = episodesData![(indexPath as NSIndexPath).row]

                if favorite["Name"] as! String == episode["Name"] as! String {
                    isFavorite = true
                    break
                }
            }
        }
        favoritesButton.setImage(UIImage(named: isFavorite ? "Cell Favorite.png" : "Cell Not Favorite.png"), for: UIControlState())
        
        return cell
    }
    
    @IBAction func toggleFavorite(_ sender: UIButton) {
        if favoritesData == nil {
            favoritesData = [[String: AnyObject]]()
        }
        
        var isFavorite = false
        let index = (self.episodesTable.indexPath(for: (sender.superview?.superview as! UITableViewCell))! as NSIndexPath).row
        
        if favoritesData != nil {
            for var favoriteIndex = 0; favoriteIndex < favoritesData?.count; favoriteIndex += 1 {
                if favoritesData?[favoriteIndex]["Name"] as! String == episodesData?[index]["Name"] as! String {
                    isFavorite = true
                    favoritesData?.remove(at: favoriteIndex)
                    UIView.transition(with: sender, duration: 0.2, options: .transitionCrossDissolve, animations: { () -> Void in
                        sender.setImage(UIImage(named: "Cell Not Favorite.png"), for: UIControlState())
                        }, completion: nil)
                    break
                }
            }
        }
        
        if !isFavorite {
            favoritesData?.insert(episodesData![index], at: 0)
            UIView.transition(with: sender, duration: 0.2, options: .transitionCrossDissolve, animations: { () -> Void in
                sender.setImage(UIImage(named: "Cell Favorite.png"), for: UIControlState())
                }, completion: nil)
        }
        
        UserDefaults.standard().set(favoritesData, forKey: "Favorites")
        
        if delegate != nil {
            self.delegate?.updatedFavorites()
        }
    }
    
    func refreshData() {
        
        let urlRequest = URLRequest(url: URL(string: "http://dl.dropboxusercontent.com/u/55399127/communitybalance.net/App_Property_List_files/Episodes.plist")!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: OperationQueue.main()) { (response, data, error) -> Void in
            if error == nil {
                UIApplication.shared().isNetworkActivityIndicatorVisible = false
                
                do {
                    self.episodesData = try PropertyListSerialization.propertyList(from: data!, options: PropertyListSerialization.MutabilityOptions(), format: nil) as? [[String: AnyObject]]
                } catch {
                    
                }
                
                self.episodesTable.reloadData()
                self.refreshControl.endRefreshing()
                
                if self.delegate != nil {
                    self.delegate?.reloadedData()
                }
            }
            else {
                UIApplication.shared().isNetworkActivityIndicatorVisible = false
                self.refreshControl.endRefreshing()
                
                let refreshFailedAlert = UIAlertController(title: "Failed to Load Episodes", message: "Check your network connection.", preferredStyle: .alert)
                refreshFailedAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
                self.present(refreshFailedAlert, animated: true, completion: nil)
            }
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Episode Detail" {
            let watchDetailVC = (segue.destinationViewController as! UINavigationController).topViewController as! WatchDetailViewController
            
            if let cell = sender as? UITableViewCell {
                if let cellIndexRow = (episodesTable.indexPath(for: cell) as NSIndexPath?)?.row {
                    watchDetailVC.episodeInfo = episodesData![cellIndexRow]
                }
            }
            
            watchDetailVC.delegate = self
            self.delegate = watchDetailVC
            
            watchDetailVC.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            watchDetailVC.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    func updatedFavorites() {
        if let favorites = UserDefaults.standard().array(forKey: "Favorites") as? [[String: AnyObject]] {
            self.favoritesData = favorites
        }
        
        let selectedIndex = episodesTable.indexPathForSelectedRow
        self.episodesTable.reloadData()
        if selectedIndex != nil {
            self.episodesTable.selectRow(at: selectedIndex, animated: false, scrollPosition: .none)
        }
    }
    
    func shouldClearIfRemoved() -> Bool {
        return false
    }

}

//
//  WatchDetailViewController.swift
//  Community Balance
//
//  Created by Anant Jain on 12/28/14.
//  Copyright (c) 2014 Anant Jain. All rights reserved.
//

import UIKit
import SafariServices
import WebKit

protocol WatchDetailViewControllerDelegate {
    func updatedFavorites()
    func shouldClearIfRemoved() -> Bool
}

class WatchDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WatchViewControllerDelegate, OrganizationWebsiteViewControllerDelegate, VideoViewControllerDelegate, FavoritesViewControllerDelegate, SFSafariViewControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var episodeBannerView: UIView!
    @IBOutlet weak var selectEpisodeLabel: UILabel!
    @IBOutlet weak var episodeImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var favoritesButton: UIButton!
    
    @IBOutlet weak var episodesTable: UITableView!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var organizationHasSite = false
    
    var episodeIsInFavorites = false
    
    var episodeInfo: [String: AnyObject]?
    var favoritesData: [[String: AnyObject]]?
    
    var delegate: WatchDetailViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard
            let info = episodeInfo
        else {
            return
        }
        
        episodeIsInFavorites = false
        
        if let favorites = UserDefaults.standard.array(forKey: "Favorites") as? [[String: AnyObject]] {
            self.favoritesData = favorites
            for favorite in favorites {
                if favorite["Name"] as! String == info["Name"] as! String {
                    episodeIsInFavorites = true
                    break
                }
            }
        }
        
        if episodeIsInFavorites {
            self.favoritesButton.setImage(UIImage(named: "Button Favorite.png"), for: UIControlState())
        }
        else {
            if (self.delegate?.shouldClearIfRemoved() != false) {
                self.episodeBannerView.isHidden = true
                self.episodesTable.isHidden = true
                self.selectEpisodeLabel.isHidden = false
                
                self.navigationItem.setRightBarButton(nil, animated: false)
                
                self.episodeInfo = nil
            }
            self.favoritesButton.setImage(UIImage(named: "Button Not Favorite.png"), for: UIControlState())
        }
        
        if let _ = info["Site"] as? String {
            organizationHasSite = true
        }
        
        self.episodesTable.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let _ = episodeInfo {
            self.titleLabel.text = self.episodeInfo!["Name"] as? String
            self.descriptionLabel.text = self.episodeInfo!["Description"] as? String
            
            self.selectEpisodeLabel.isHidden = true
            
            self.navigationItem.setRightBarButton(self.shareButton, animated: true)
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            let urlRequest = URLRequest(url: URL(string: episodeInfo!["Image"] as! String)!)
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: OperationQueue.main) { (response, data, error) -> Void in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                if error == nil {
                    self.episodeImage.image = UIImage(data: data!)
                }
                
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.episodeImage.alpha = 1.0
                })
            }
        }
        else {
            self.episodeBannerView.isHidden = true
            self.episodesTable.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return organizationHasSite ? 3 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if let info = episodeInfo {
                return (info["Links"] as! [String]).count
            }
            else {
                return 0
            }
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 2 {
            return "Visit the website of the organization featured in this episode."
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            if episodeInfo != nil {
                cell.textLabel?.text = (episodeInfo!["Links"] as! [String]).count > 1 ? "Watch Part \((indexPath as NSIndexPath).row + 1)" : "Watch Episode"
            }
        case 1:
            cell.textLabel?.text = episodeIsInFavorites ? "Remove from Favorites" : "Add to Favorites"
        case 2:
            cell.textLabel?.text = "Visit Organization Website"
        default:
            break
        }
        
        cell.textLabel?.textAlignment = .center
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).section {
        case 0:
            performSegue(withIdentifier: "Show Episode", sender: indexPath)
        case 1:
            toggleFavorite(favoritesButton)
        case 2:
            if #available(iOS 9.0, *) {
                let safariVC = SFSafariViewController(url: URL(string: episodeInfo!["Site"] as! String)!)
                safariVC.modalPresentationStyle = .pageSheet
                safariVC.delegate = self
                
                present(safariVC, animated: true, completion: nil)
            }
            else {
                performSegue(withIdentifier: "Organization Website", sender: nil)
            }
        default:
            break
        }
    }
    
    @IBAction func shareEpisode(_ sender: UIBarButtonItem) {
        if let links = episodeInfo!["Links"] as? [String] {
            let shareSheet = UIActivityViewController(activityItems: [URL(string: links[0])!], applicationActivities: nil)
            
            shareSheet.modalPresentationStyle = .popover
            shareSheet.popoverPresentationController?.barButtonItem = sender
            present(shareSheet, animated: true, completion: nil)
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        print("called")
        return .none
    }
    
    @IBAction func toggleFavorite(_ sender: UIButton) {
        if favoritesData == nil {
            favoritesData = [[String: AnyObject]]()
        }
        
        if (delegate?.shouldClearIfRemoved() != false) {
            
            performSegue(withIdentifier: "Return to Favorites", sender: nil)
            
            self.episodeBannerView.isHidden = true
            self.episodesTable.isHidden = true
            self.selectEpisodeLabel.isHidden = false
            
            self.navigationItem.setRightBarButton(nil, animated: true)
            self.navigationItem.setLeftBarButton(nil, animated: true)
        }
        
        var isFavorite = false
        
        if favoritesData != nil {
            for favoriteIndex in 0..<favoritesData!.count {
                if favoritesData?[favoriteIndex]["Name"] as! String == episodeInfo!["Name"] as! String {
                    isFavorite = true
                    favoritesData?.remove(at: favoriteIndex)
                    UIView.transition(with: sender, duration: 0.2, options: .transitionCrossDissolve, animations: { () -> Void in
                        sender.setImage(UIImage(named: "Button Not Favorite.png"), for: UIControlState())
                        }, completion: nil)
                    break
                }
            }
        }
        
        if !isFavorite {
            favoritesData?.insert(episodeInfo!, at: 0)
            UIView.transition(with: sender, duration: 0.2, options: .transitionCrossDissolve, animations: { () -> Void in
                sender.setImage(UIImage(named: "Button Favorite.png"), for: UIControlState())
                }, completion: nil)
        }
        
        episodeIsInFavorites = !isFavorite
        self.episodesTable.reloadData()
        
        UserDefaults.standard.set(favoritesData, forKey: "Favorites")
        
        if delegate != nil {
            delegate?.updatedFavorites()
        }
        
        if (delegate?.shouldClearIfRemoved() != false) {
            self.episodeInfo = nil
        }
    }
    
    func updatedFavorites() {
        if let favorites = UserDefaults.standard.array(forKey: "Favorites") as? [[String: AnyObject]] {
            self.favoritesData = favorites
        }
        
        if favoritesData == nil {
            favoritesData = [[String: AnyObject]]()
        }
        
        var isFavorite = false
        
        if favoritesData != nil {
            for favoriteIndex in 0..<favoritesData!.count {
                if favoritesData?[favoriteIndex]["Name"] as! String == episodeInfo!["Name"] as! String {
                    isFavorite = true
                    favoritesButton.setImage(UIImage(named: "Button Favorite.png"), for: UIControlState())
                    break
                }
            }
        }
        
        if !isFavorite {
            favoritesButton.setImage(UIImage(named: "Button Not Favorite.png"), for: UIControlState())
        }
        
        episodeIsInFavorites = isFavorite
        self.episodesTable.reloadData()
        
        UserDefaults.standard.set(favoritesData, forKey: "Favorites")
    }
    
    func reloadedData() {
        self.episodeBannerView.isHidden = true
        self.episodesTable.isHidden = true
        self.selectEpisodeLabel.isHidden = false
        
        self.navigationItem.setRightBarButton(nil, animated: true)
        
        self.episodeInfo = nil
    }
    
    func dismissedWebsite() {
        if let index = self.episodesTable.indexPathForSelectedRow {
            self.episodesTable.deselectRow(at: index, animated: true)
        }
    }
    
    func closedVideo() {
        if let index = self.episodesTable.indexPathForSelectedRow {
            self.episodesTable.deselectRow(at: index, animated: true)
        }
    }
    
    func updatedFavoritesList() {
        if let favorites = UserDefaults.standard.array(forKey: "Favorites") as? [[String: AnyObject]] {
            self.favoritesData = favorites
        }
        if favoritesData == nil {
            favoritesData = [[String: AnyObject]]()
        }
        
        var isFavorite = false
        
        if favoritesData != nil && episodeInfo != nil {
            for favoriteIndex in 0..<favoritesData!.count {
                if favoritesData?[favoriteIndex]["Name"] as! String == episodeInfo!["Name"] as! String {
                    isFavorite = true
                    break
                }
            }
        }
        
        if !isFavorite {
            performSegue(withIdentifier: "Return to Favorites", sender: nil)
            
            self.episodeBannerView.isHidden = true
            self.episodesTable.isHidden = true
            self.selectEpisodeLabel.isHidden = false
            
            self.navigationItem.setRightBarButton(nil, animated: true)
            self.navigationItem.setLeftBarButton(nil, animated: true)
            
            self.episodeInfo = nil
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Episode" {
            let videoVC = (segue.destination as! UINavigationController).topViewController as! VideoViewController
            videoVC.videoHTMLString = YouTubeViewer.HTMLStringWithVideoURLString((episodeInfo!["Links"] as! [String])[((sender as! IndexPath) as NSIndexPath).row])
            videoVC.navigationTitle = self.tableView(self.episodesTable, cellForRowAt: sender as! IndexPath).textLabel?.text
            videoVC.delegate = self
        }
        else if segue.identifier == "Organization Website" {
            let organizationWebsiteVC = (segue.destination as! UINavigationController).topViewController as! OrganizationWebsiteViewController
            organizationWebsiteVC.websiteURLRequest = URLRequest(url: URL(string: episodeInfo!["Site"] as! String)!)
            organizationWebsiteVC.delegate = self
        }
    }
    
    @available(iOS 9.0, *)
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        if let index = self.episodesTable.indexPathForSelectedRow {
            self.episodesTable.deselectRow(at: index, animated: true)
        }
    }

}

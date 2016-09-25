//
//  FavoritesViewController.swift
//  Community Balance
//
//  Created by Anant Jain on 12/29/14.
//  Copyright (c) 2014 Anant Jain. All rights reserved.
//

import UIKit

protocol FavoritesViewControllerDelegate {
    func updatedFavoritesList()
}

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WatchDetailViewControllerDelegate {
    
    @IBOutlet weak var favoritesTable: UITableView!
    @IBOutlet weak var noFavoritesView: UIView!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var currentlySelected: IndexPath?
    
    var delegate: FavoritesViewControllerDelegate?
    
    var favoritesData: [[String: AnyObject]]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoritesData = UserDefaults.standard.array(forKey: "Favorites") as? [[String: AnyObject]]
        if favoritesData != nil && favoritesData?.count != 0 {
            self.favoritesTable.reloadData()
            
            self.favoritesTable.isHidden = false
            self.favoritesTable.alpha = 1.0
            self.noFavoritesView.isHidden = true
            self.noFavoritesView.alpha = 0.0
            
            self.navigationItem.leftBarButtonItem = self.editButton
        }
        else {
            self.favoritesTable.isHidden = true
            self.favoritesTable.alpha = 0.0
            self.noFavoritesView.isHidden = false
            self.noFavoritesView.alpha = 1.0
            
            self.navigationItem.leftBarButtonItem = nil
        }
        
        self.favoritesTable.setEditing(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        let detailNavVC = self.splitViewController?.viewControllers[1] as! UINavigationController
//        detailNavVC.topViewController!.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
        
        self.splitViewController?.preferredDisplayMode = .allVisible
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return favoritesData != nil ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favoritesData != nil {
            return favoritesData!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell
        
        cell.textLabel?.text = favoritesData![(indexPath as NSIndexPath).row]["Name"] as? String
        cell.detailTextLabel?.text = favoritesData![(indexPath as NSIndexPath).row]["Description"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            self.favoritesData?.remove(at: (indexPath as NSIndexPath).row)
            self.favoritesTable.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            UserDefaults.standard.set(self.favoritesData, forKey: "Favorites")
            
            if self.delegate != nil {
                self.delegate?.updatedFavoritesList()
            }
            
            if self.favoritesData?.count == 0 {
                self.favoritesTable.setEditing(false, animated: true)
                self.navigationItem.setLeftBarButton(nil, animated: true)
                
                self.noFavoritesView.isHidden = false
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.favoritesTable.alpha = 0.0
                    self.noFavoritesView.alpha = 1.0
                    }, completion: { (completed: Bool) -> Void in
                        self.favoritesTable.isHidden = true
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let dataToMove = favoritesData![(sourceIndexPath as NSIndexPath).row]
        self.favoritesData?.remove(at: (sourceIndexPath as NSIndexPath).row)
        self.favoritesData?.insert(dataToMove, at: (destinationIndexPath as NSIndexPath).row)
        UserDefaults.standard.set(self.favoritesData, forKey: "Favorites")
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        self.navigationItem.setLeftBarButton(self.doneButton, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        if favoritesData?.count != 0 {
            self.navigationItem.setLeftBarButton(self.editButton, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove from Favorites"
    }
    
    @IBAction func editFavorites(_ sender: AnyObject) {
        self.navigationItem.setLeftBarButton(self.doneButton, animated: true)
        self.favoritesTable.setEditing(true, animated: true)
    }
    
    @IBAction func finishEditingFavorites(_ sender: AnyObject) {
        self.navigationItem.setLeftBarButton(self.editButton, animated: true)
        self.favoritesTable.setEditing(false, animated: true)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Episode Detail" {
            let watchDetailVC = (segue.destination as! UINavigationController).topViewController as! WatchDetailViewController
            if let cell = sender as? UITableViewCell {
                if let cellIndexRow = (favoritesTable.indexPath(for: cell) as NSIndexPath?)?.row {
                    watchDetailVC.episodeInfo = favoritesData![cellIndexRow]
                    currentlySelected = IndexPath(row: cellIndexRow, section: 0)
                }
            }
            watchDetailVC.delegate = self
            self.delegate = watchDetailVC
            
            watchDetailVC.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            watchDetailVC.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    @IBAction func returnToFavoritesVC(_ segue: UIStoryboardSegue) {
        
    }
    
    func shouldClearIfRemoved() -> Bool {
        return true
    }
    
    func updatedFavorites() {
        if let favorites = UserDefaults.standard.array(forKey: "Favorites") as? [[String: AnyObject]] {
            self.favoritesData = favorites
        }
        self.favoritesTable.deleteRows(at: [currentlySelected!], with: UITableViewRowAnimation.automatic)
        
        if self.favoritesData?.count == 0 {
            self.favoritesTable.setEditing(false, animated: true)
            self.navigationItem.setLeftBarButton(nil, animated: true)
            
            self.noFavoritesView.isHidden = false
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.favoritesTable.alpha = 0.0
                self.noFavoritesView.alpha = 1.0
                }, completion: { (completed: Bool) -> Void in
                    self.favoritesTable.isHidden = true
            })
        }
    }
}

//
//  WatchDetailNavigationController.swift
//  Community Balance
//
//  Created by Anant Jain on 11/26/15.
//  Copyright © 2015 Anant Jain. All rights reserved.
//

import UIKit

class WatchDetailNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @available(iOS 9.0, *)
    override func previewActionItems() -> [UIPreviewActionItem] {
        guard let watchDetailVC = viewControllers.first as? WatchDetailViewController else {
            return []
        }
        
        let favoritesToggleItem = UIPreviewAction(title: (watchDetailVC.episodeIsInFavorites ? "Remove from Favorites" : "Add to Favorites"), style: .default) { (action, vc) -> Void in
            watchDetailVC.toggleFavorite(watchDetailVC.favoritesButton)
        }
        
        return [favoritesToggleItem]
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

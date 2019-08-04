//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Julio Cesar Whatley on 8/3/19.
//  Copyright © 2019 Capi. All rights reserved.
//

import UIKit
import Foundation

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create Meme", style: .plain, target: self, action: #selector(openMemeCreator))
    }
    
    override func viewWillAppear(_ animated: Bool) {
//      collectionView.reloadData()
        tableView!.reloadData()
    }
    
    @objc func openMemeCreator() {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeCreatorViewController") as! MemeCreatorViewController
        self.present(detailController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableMemeCell")!
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topText
        cell.detailTextLabel?.text = meme.topText
        cell.imageView?.image = meme.memedImage
        cell.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "VillainDetailViewController") as! VillainDetailViewController
//        detailController.villain = self.allVillains[(indexPath as NSIndexPath).row]
//        self.navigationController!.pushViewController(detailController, animated: true)
//    }
}

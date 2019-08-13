//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Julio Cesar Whatley on 8/3/19.
//  Copyright © 2019 Capi. All rights reserved.
//

import UIKit
import Foundation

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create Meme", style: .plain, target: self, action: #selector(openMemeCreator))
        
        let space:CGFloat = 3.0
        let width = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: width)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView!.reloadData()
    }
    
    @objc func openMemeCreator() {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeCreatorViewController") as! MemeCreatorViewController
        self.present(detailController, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.memeImageView?.image = meme.originalImage
        cell.memeImageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailsViewController") as! MemeDetailsViewController
        detailController.memeDetails = memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}

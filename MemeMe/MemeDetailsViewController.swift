//
//  MemeDetailsViewController.swift
//  MemeMe
//
//  Created by Julio Cesar Whatley on 8/12/19.
//  Copyright © 2019 Capi. All rights reserved.
//

import UIKit
import Foundation

class MemeDetailsViewController: UIViewController {
    
    var memeDetails: Meme!
    
    @IBOutlet weak var memeView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeView!.image = memeDetails.memedImage
    }
}

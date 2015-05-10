//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Venkata Vijay on 5/9/15.
//  Copyright (c) 2015 Venkata Vijay. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var criticScore: UILabel!
    @IBOutlet weak var audienceScore: UILabel!
    
    var imageURL:NSURL? = nil
    var critics:String? = nil
    var audience:String? = nil
    
    override func viewDidLoad() {
        SVProgressHUD.show()
        self.movieImage.setImageWithURL(imageURL)
        self.criticScore.text = critics!
        self.audienceScore.text = audience!
        SVProgressHUD.dismiss()
    }
}

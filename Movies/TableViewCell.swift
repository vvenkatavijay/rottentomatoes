//
//  TableViewCell.swift
//  Movies
//
//  Created by Venkata Vijay on 5/9/15.
//  Copyright (c) 2015 Venkata Vijay. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieThumbnail: UIImageView!
    @IBOutlet weak var mpaaLabel: UILabel!
    @IBOutlet weak var movieSynopsis: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

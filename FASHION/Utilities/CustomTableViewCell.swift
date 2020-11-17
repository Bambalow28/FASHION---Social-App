//
//  CustomTableViewCell.swift
//  FASHION
//
//  Created by Joshua Alanis on 2020-08-14.
//  Copyright © 2020 Joshua Alanis. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class CustomTableViewCell: UITableViewCell  {

    @IBOutlet weak var cellVIew: UIView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

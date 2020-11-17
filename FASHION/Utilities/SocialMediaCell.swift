//
//  SocialMediaCell.swift
//  FASHION
//
//  Created by Joshua Alanis on 2020-10-02.
//  Copyright © 2020 Joshua Alanis. All rights reserved.
//

import UIKit

class SocialMediaCell: UITableViewCell {

    @IBOutlet weak var socialMediaView: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timePosted: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var likePost: UIButton!
    @IBOutlet weak var commentPost: UIButton!
    @IBOutlet weak var postCaption: UILabel!
    
    var likeStatus = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if (likeStatus > 0) {
            likePost.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
            tap.numberOfTapsRequired = 2
            postImage.addGestureRecognizer(tap)

    }
    
    @objc func doubleTapped() {
        likePost.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func likeBtnClicked(_ sender: Any) {

        if(likeStatus == 0) {
            likeStatus = 1
            likePost.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        else {
            likeStatus = 0
            likePost.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}

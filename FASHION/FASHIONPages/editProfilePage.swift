//
//  editProfilePage.swift
//  FASHION
//
//  Created by Joshua Alanis on 2020-11-15.
//  Copyright © 2020 Joshua Alanis. All rights reserved.
//

import UIKit

class editProfilePage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "EDIT PROFILE"
    }
    
    @IBAction func returnBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

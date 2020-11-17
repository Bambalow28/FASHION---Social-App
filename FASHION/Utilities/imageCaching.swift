//
//  imageCaching.swift
//  FASHION
//
//  Created by Joshua Alanis on 2020-09-24.
//  Copyright © 2020 Joshua Alanis. All rights reserved.
//

import Foundation
import UIKit

class imageCaching {
    
    static func downloadedImage(withURL url:URL, completion: @escaping (_ image: UIImage?) -> ()) {
        
        let dataTask = URLSession.shared.dataTask(with: url) {data, url, error in
            var downloadedImage: UIImage?
            
            if let data = data {
                downloadedImage = UIImage(data: data)
            }
            
            DispatchQueue.main.async {
                completion(downloadedImage)
            }
        }
        
        dataTask.resume()
    }
}

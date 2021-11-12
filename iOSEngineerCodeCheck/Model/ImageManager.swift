//
//  ImageManager.swift
//  iOSEngineerCodeCheck
//
//  Created by 佐藤駿樹 on 2021/11/12.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation
import UIKit

class ImageManager {
    
    static let instance = ImageManager()
    
    func getAvatarImage(repo: [String : Any]?, handler: @escaping( _ image: UIImage?) -> ()){
        if let owner = repo![RepositoryData.Items.owner] as? [String: Any],
           let imgURL = owner[RepositoryData.Items.Owner.avatarUrl] as? String {
            
            self.getImage(urlString: imgURL) { returnedImage in
                handler(returnedImage)
            }
        }
    }
    
    private func getImage(urlString: String, handler: @escaping (_ image: UIImage?) -> ()) {

        URLSession.shared.dataTask(with: URL(string: urlString)!) { data, res, error in
            if error != nil {
                print("ERROR: \(error!.localizedDescription)")
                handler(nil)
                return
            }
            if let data = data {
                let image = UIImage(data: data)
                handler(image)
                return
            }
        }
        .resume()
    }
}



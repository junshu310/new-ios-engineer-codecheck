//
//  AnalyticsModel.swift
//  iOSEngineerCodeCheck
//
//  Created by 佐藤駿樹 on 2021/11/12.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

class AnalyticsModel {
    
    static let instance = AnalyticsModel()
    
    ///USED PARSE URL
    func parse(urlString: String, handler: @escaping (_ success: Bool, _ items: [[String : Any]]?) -> ()) {
        
        let encordURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let task = URLSession.shared.dataTask(with: URL(string: encordURL!)!) { (data, res, error) in
            //error
            if error != nil {
                print("ERROR: \(error!.localizedDescription)")
                handler(false, nil)
                return
            }
            //success
            if let data = data {
                let obj = try! JSONSerialization.jsonObject(with: data) as? [String: Any]
                let items = obj![RepositoryData.items] as? [[String: Any]]
                handler(true, items!)
                return
            }
        }
        // これ呼ばなきゃリストが更新されません
        task.resume()
    }
}

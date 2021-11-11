//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var langLabel: UILabel!
    
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!
    
    var repo = [String : Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        getInfo(repo: repo)
        getImage(repo: repo)
    }
    
    //MARK: FUNCTIONS
    
    func getInfo(repo: [String : Any]) {
        titleLabel.text = repo["full_name"] as? String
        langLabel.text = "Written in \(repo["language"] as? String ?? "")"
        starsLabel.text = "\(repo["stargazers_count"] as? Int ?? 0) stars"
        watchersLabel.text = "\(repo["wachers_count"] as? Int ?? 0) watchers"
        forksLabel.text = "\(repo["forks_count"] as? Int ?? 0) forks"
        issuesLabel.text = "\(repo["open_issues_count"] as? Int ?? 0) open issues"
    }
    
    func getImage(repo: [String : Any]) {
        
        if let owner = repo["owner"] as? [String: Any],
           let imgURL = owner["avatar_url"] as? String {
            URLSession.shared.dataTask(with: URL(string: imgURL)!) { (data, res, error) in
                if error != nil {
                    print("ERROR: \(error!.localizedDescription)")
                    return
                }
                if let data = data {
                    let img = UIImage(data: data)!
                    DispatchQueue.main.async {
                        self.imageView.image = img
                    }
                }
            }
            .resume()
        }
    }
}

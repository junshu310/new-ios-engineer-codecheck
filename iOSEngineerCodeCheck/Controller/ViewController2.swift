//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import SafariServices

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
        
        navigationItem.title = "リポジトリ詳細"
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        
        presentData(repo: repo)
        presentAvatarImage(repo: repo)
    }
    
    @IBAction func toSafari(_ sender: Any) {
        
        if let urlString = repo[RepositoryData.Items.url] as? String {
            
            let url = URL(string: urlString)
            let safariVC = SFSafariViewController(url: url!)
            self.present(safariVC, animated: true, completion: nil)
        }
    }
    
    //MARK: FUNCTIONS
    
    func presentData(repo: [String : Any]) {
        titleLabel.text = repo[RepositoryData.Items.fullName] as? String
        langLabel.text = "Written in \(repo[RepositoryData.Items.lang] as? String ?? "")"
        starsLabel.text = "\(repo[RepositoryData.Items.stars] as? Int ?? 0) stars"
        watchersLabel.text = "\(repo[RepositoryData.Items.watchers] as? Int ?? 0) watchers"
        forksLabel.text = "\(repo[RepositoryData.Items.forks] as? Int ?? 0) forks"
        issuesLabel.text = "\(repo[RepositoryData.Items.issues] as? Int ?? 0) open issues"
    }
    
    func presentAvatarImage(repo: [String : Any]) {
        ImageManager.instance.getAvatarImage(repo: repo) { image in
            if let image = image {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
}

//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var repositorySearchBar: UISearchBar!
    
    var responses: [[String : Any]] = []
    
    var task: URLSessionTask?
    var keyword: String = ""
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        repositorySearchBar.placeholder = "GitHubのリポジトリを検索できるよー"
        repositorySearchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        keyword = searchBar.text!.removeWhitespacesAndNewlines
        
        if keyword.count != 0 {
            let url = "https://api.github.com/search/repositories?q=\(keyword)"
            let encordURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            task = URLSession.shared.dataTask(with: URL(string: encordURL!)!) { (data, res, err) in
                
                if let obj = try! JSONSerialization.jsonObject(with: data!) as? [String: Any],
                   let items = obj["items"] as? [[String: Any]] {
                    self.responses = items
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            // これ呼ばなきゃリストが更新されません
            task?.resume()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Detail"{
            let detail = segue.destination as? ViewController2
            detail?.vc1 = self
        }
    }
    
    
    //MARK: TABLEVIEW CELL
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Repository")
        let response = responses[indexPath.row]
        cell.textLabel?.text = response["full_name"] as? String ?? ""
        print(response["language"] as? String ?? "")
        cell.detailTextLabel?.text = response["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移時に呼ばれる
        index = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}


extension StringProtocol where Self: RangeReplaceableCollection {
    ///スペースを取り除き、新しい文を返す
    var removeWhitespacesAndNewlines: Self {
        filter { !$0.isNewline && !$0.isWhitespace }
    }
}

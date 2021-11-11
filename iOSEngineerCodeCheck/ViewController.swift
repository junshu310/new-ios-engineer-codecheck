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
        
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        repositorySearchBar.placeholder = "GitHubのリポジトリを検索できるよー"
        repositorySearchBar.delegate = self
        //スクロールでキーボードを閉じる
        tableView.keyboardDismissMode = .onDrag
        
        activityIndicator.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/3)
        activityIndicator.style = .large
        view.addSubview(activityIndicator)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        keyword = searchBar.text!.removeWhitespacesAndNewlines
        
        if keyword.count != 0 {
            searchBar.resignFirstResponder()
            activityIndicator.startAnimating()
            let url = "https://api.github.com/search/repositories?q=\(keyword)"
            let encordURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            task = URLSession.shared.dataTask(with: URL(string: encordURL!)!) { (data, res, err) in
                if let err = err {
                    DispatchQueue.main.async {
                        //以下は、メインスレッドで呼ぶ
                        self.activityIndicator.stopAnimating()
                        self.showError(message: "通信状況を確認し、\nもう一度お試し下さい。")
                    }
                    print("ERROR: \(err)")
                    return
                }
                if let data = data {
                    let obj = try! JSONSerialization.jsonObject(with: data) as? [String: Any]
                    let items = obj!["items"] as? [[String: Any]]
                    self.responses = items!
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.tableView.reloadData()
                    }
                }
            }
            // これ呼ばなきゃリストが更新されません
            task?.resume()
        } else {
            showError(message: "文字を入力して下さい。")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Detail"{
            let vc2 = segue.destination as? ViewController2
            vc2?.repo = responses[index]
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
        cell.detailTextLabel?.text = response["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        repositorySearchBar.resignFirstResponder()
        // 画面遷移時に呼ばれる
        index = indexPath.row
        performSegue(withIdentifier: "Detail", sender: nil)
    }
    
    
    //MARK: FUNCTIONS
    
    func showError(message: String) {
        let alert: UIAlertController = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default)

        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}


extension StringProtocol where Self: RangeReplaceableCollection {
    ///スペースを取り除き、新しい文を返す
    var removeWhitespacesAndNewlines: Self {
        filter { !$0.isNewline && !$0.isWhitespace }
    }
}

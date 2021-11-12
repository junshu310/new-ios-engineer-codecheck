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
    
    var responses = [[String : Any]]()
    
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
            let urlString = "https://api.github.com/search/repositories?q=\(keyword)"
            
            AnalyticsModel.instance.parse(urlString: urlString) { success, items in
                if success {
                    self.responses = items!
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.tableView.reloadData()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.showError(title: "Error!", message: "読み込みに失敗しました。")
                    }
                }
            }
        } else {
            self.showError(title: "Error!", message: "文字を入力して下さい。")
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
        cell.textLabel?.text = response[RepositoryData.Items.fullName] as? String ?? ""
        cell.detailTextLabel?.text = response[RepositoryData.Items.lang] as? String ?? ""
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
    
    func showError(title: String?, message: String?) {
        
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default)

        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

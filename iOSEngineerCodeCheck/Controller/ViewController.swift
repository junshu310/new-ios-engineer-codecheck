//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let repositorySearchBar = UISearchBar()
    
    var responses = [[String : Any]]()
    
    var keyword: String = ""
    var index: Int = 0
        
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        repositorySearchBar.placeholder = "GitHubのリポジトリを検索できるよー"
        repositorySearchBar.delegate = self
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        //スクロールでキーボードを閉じる
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "GitHub リポジトリ検索"
        navigationItem.backButtonTitle = " "
        
        activityIndicator.center = CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/3)
        activityIndicator.style = .large
        self.view.addSubview(activityIndicator)
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
                        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
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
    
    
    //MARK: TABLEVIEW
    
    //section使う時に必須のメソッド
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return repositorySearchBar
    }
    
    //searchBarの幅に合わせる為に必要な処理
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomCell
        let response = responses[indexPath.row]
        cell.titleLabel.text = response[RepositoryData.Items.fullName] as? String ?? ""
        cell.langLabel.text = response[RepositoryData.Items.lang] as? String ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        repositorySearchBar.resignFirstResponder()
        tableView.deselectRow(at: indexPath, animated: true)
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

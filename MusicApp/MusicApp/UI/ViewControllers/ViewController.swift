//
//  ViewController.swift
//  MusicApp
//
//  Created by Sachin Gupta on 3/8/21.
//

import UIKit

class MusicListViewController: RootViewController {
    let tableViewDataSource = TableViewDataSource(data: [MusicViewModel(title:"Hello"),MusicViewModel(title:"Dear"),MusicViewModel(title:"Apple")])
    lazy var tableView:UITableView  = {
    let tv = UITableView()
    tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(MusicTableViewCell<MusicViewModel>.self, forCellReuseIdentifier: "MusicTableViewCellIdentifier")
    return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.delegate = self
        tableView.dataSource = self.tableViewDataSource
        // Do any additional setup after loading the view.
    }
    override func setupView() {
        view.addSubview(tableView)
        tableView.rowHeight = UITableView.automaticDimension;
        //tableView.estimatedRowHeight = 44.0;
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
       
    }

}

extension MusicListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


//
//  ViewController.swift
//  MusicApp
//
//  Created by Sachin Gupta on 3/8/21.
//

import UIKit
import Combine
class MusicListViewController: RootViewController {
    var musicListModel = Array<MusicModel>()
    var cancellable:Cancellable?
    lazy var tableView:UITableView  = {
    let tv = UITableView()
    tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(MusicTableViewCell<MusicModel>.self, forCellReuseIdentifier: "MusicTableViewCellIdentifier")
        tv.tableFooterView = UIView()
    return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func setupView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 8).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: 8).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    override func loadData() {
        self.title = NSLocalizedString("Song List", comment: "")
        let res = Resource(url: ApiEndPoints.getSongList.rawValue, httpMethod: .GET)
        cancellable = WebService().APIRequest(resource: res).sink { (_) in
            
        } receiveValue: { (value) in
                let parser = MusicFeedParser(xmlData: value,completion: {[weak self] (musicListModel) in
                    self?.musicListModel.removeAll()
                    self?.musicListModel = musicListModel
                    self?.tableView.reloadData()
                })
                parser.parse()
        }
    }

}


extension MusicListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = SongDetailViewController()
        viewController.musicModel = musicListModel[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: false)
    }
}

extension MusicListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicListModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"MusicTableViewCellIdentifier")
        if let cell = cell as? RootTableViewCell<MusicModel> {
            cell.configureCell(model: musicListModel[indexPath.row])
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
}

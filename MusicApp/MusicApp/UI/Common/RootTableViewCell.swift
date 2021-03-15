//
//  RootTableViewCell.swift
//  MusicApp
//
//  Created by Sachin Gupta on 3/9/21.
//

import Foundation
import UIKit

class RootTableViewCell<T>:UITableViewCell {
    var model:T?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureCell(model:T){
        self.model = model
    }
    func setupUI(){
        
    }
}

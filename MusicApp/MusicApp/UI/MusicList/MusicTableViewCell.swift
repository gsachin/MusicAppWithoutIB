//
//  MusicTableViewCell.swift
//  MusicApp
//
//  Created by Sachin Gupta on 3/9/21.
//

import Foundation
import UIKit

class MusicTableViewCell<T>: RootTableViewCell<T> {

    lazy var cellContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [self.thumbnailImage,titleAndSubTitleContainerView].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    lazy var titleAndSubTitleContainerView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [self.titleLabel,self.artistLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    lazy var thumbnailImage : LazyImageView = {
        let image = LazyImageView()
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: 55),
            image.widthAnchor.constraint(equalToConstant: 55)
        ])
        return image
    }()
    
    lazy var artistLabel:UILabel = {
        let label = UILabel()
         label.numberOfLines = 1
         label.font = UIFont(descriptor:UIFontDescriptor(name: "System", size: 11), size: 11)
         label.translatesAutoresizingMaskIntoConstraints = false
        return label
        }()
    lazy var titleLabel: UILabel =  {
       let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont(descriptor:UIFontDescriptor(name: "System", size: 13), size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
       return label
       }()
    
    override func configureCell(model: T) {
        super.configureCell(model: model)
        if let model = model as? MusicModel{
            titleLabel.text = model.title
            artistLabel.text = model.artist
            if let urlString = model.thubnailUrl {
                thumbnailImage.loadImageAsync(url: urlString)
            }
        }
    }
    override func setupUI() {
            backgroundColor = .clear
        contentView.addSubview(cellContentStackView)
                    NSLayoutConstraint.activate([
                        cellContentStackView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 0),
                        cellContentStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
                        cellContentStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
                        cellContentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: 0),
                    ])
    }
    
   
}

//
//  SongDetailViewController.swift
//  MusicApp
//
//  Created by Sachin Gupta on 3/11/21.
//

import UIKit
import Foundation
import AVFoundation
class SongDetailViewController: RootViewController  {
    
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isDirectionalLockEnabled = true
        return scrollView
    }()
    let stackView = UIStackView()
    
    //UI Components
    lazy var playPreviewButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(playImage, for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(self.playPreviewButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    lazy var songImageView : LazyImageView = {
        let image = LazyImageView()
        image.addSubview(playPreviewButton)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        return image
    }()
    
    lazy var artistLabel:UILabel = {
        let label = UILabel()
         label.numberOfLines = 0
         label.font = UIFont(descriptor:UIFontDescriptor(name: "System", size: 16), size: 16)
         label.translatesAutoresizingMaskIntoConstraints = false
        return label
        }()
    lazy var titleLabel: UILabel =  {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(descriptor:UIFontDescriptor(name: "System", size: 16), size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
       return label
       }()
    
    
    lazy var pauseImage:UIImage = {
        let pauseimage = UIImage(systemName: "pause.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .light, scale: .large))
        let blueImage = pauseimage?.withTintColor(.blue, renderingMode: .alwaysOriginal)
        return blueImage ?? UIImage()
    }()
    lazy var playImage:UIImage = {
        let playimage = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .light, scale: .large))
        let blueImage = playimage?.withTintColor(.blue, renderingMode: .alwaysOriginal)
        return blueImage ?? UIImage()
    }()
    var musicModel:MusicModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player?.pause()
        player = nil
    }
    override func setupView() {
        if let url = musicModel?.previewUrl {
            guard let url = URL(string: url) else {
                return
            }
        self.title =  NSLocalizedString(musicModel?.title ?? "Song Details", comment:"")
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachedToEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        }
        self.view.backgroundColor = UIColor.gray
        
        //Add scroll view
        self.view.addSubview(self.scrollView)
        
        //Constrains to scroll view
        NSLayoutConstraint.activate([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8)
        ])
        //Add stack view
        self.scrollView.addSubview(self.stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.axis = .vertical
        self.stackView.spacing = 10;

        //constrains stack view to scroll view
        NSLayoutConstraint.activate([
        self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
        self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
        self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
        self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
        self.stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
    
        self.stackView.addArrangedSubview(self.songImageView)
        self.stackView.addArrangedSubview(titleLabel)
        self.stackView.addArrangedSubview(artistLabel)
        
        NSLayoutConstraint.activate([
            playPreviewButton.rightAnchor.constraint(equalTo: songImageView.rightAnchor, constant: -16),
            playPreviewButton.bottomAnchor.constraint(equalTo: songImageView.bottomAnchor, constant: -16),
            playPreviewButton.heightAnchor.constraint(equalToConstant: 50),
            playPreviewButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
     
    override func loadData() {
        if let model = musicModel {
            if let url = model.imageUrl {
                songImageView.loadImageAsync(url: url)
            }
            if let title = model.title {
                titleLabel.text = title
            }
            if let artist = model.artist {
                artistLabel.text = artist
            }
        }
    }
    
    @objc func playPreviewButtonTapped(_ sender:UIButton)
    {
        if player?.rate == 0
        {
            player?.play()
            playPreviewButton.setImage(pauseImage, for: .normal)
        } else {
            player?.pause()
            playPreviewButton.setImage(playImage, for: .normal)
        }
    }
    
    @objc func playerItemDidReachedToEnd(notification: NSNotification) {
        player?.seek(to: CMTime.zero)
        player?.pause()
        playPreviewButton.setImage(playImage, for: .normal)
    }

}


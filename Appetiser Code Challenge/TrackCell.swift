//
//  TrackCell.swift
//  Appetiser Code Challenge
//
//  Created by Ariel Dominic Cabanag on 2/5/22.
//

import Foundation
import UIKit
import SDWebImage

class TrackCell: UITableViewCell {
    //MARK: [START] Public variables
    
    static let identifier = "ArtworkCell"
    public var indexPath: IndexPath?
    
    //MARK: [END] Public variables
    
    //MARK: [START] Private UI variables
    private var model: TrackModel?
    
    private let cardView: UIView = {
        let cardView = UIView()
        cardView.layer.cornerRadius = 10.0
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cardView.layer.shadowRadius = 6.0
        cardView.layer.shadowOpacity = 0.7
        cardView.backgroundColor = .white
        cardView.enableContraints()
        return cardView
    }()
    
    private let artWorkImage: UIImageView = {
        let artWorkImage = UIImageView()
        artWorkImage.layer.cornerRadius = 2.0
        artWorkImage.layer.masksToBounds = false
        artWorkImage.clipsToBounds = true
        artWorkImage.enableContraints()
        return artWorkImage
    }()
    
    private let trackName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.text = "Track Name"
        label.enableContraints()
        return label
    }()
    
    private let trackGenre: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Track Genre"
        label.enableContraints()
        return label
    }()
    
    private let trackPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Track Price"
        label.enableContraints()
        return label
    }()
    
    private let heartButton: HeartButton = {
        let button = HeartButton()
        button.enableContraints()
        button.tintColor = .red
        button.enableContraints()
        return button
    }()
    
    //MARK: [END] Private UI variables
    
    
    /// istantiate cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // set selection style to none
        selectionStyle = .none
        contentView.isUserInteractionEnabled = true
        
        // Add Card view to Table view
        self.addSubview(cardView)
        cardView.fill(parent: self, padding: .init(top: 8 , left: 16, bottom: 8, right: 16))
        
        // Add artwork image view
        cardView.addSubview(artWorkImage)
        artWorkImage.anchor(top: cardView.topAnchor,
                            bottom: cardView.bottomAnchor,
                            leading: cardView.leadingAnchor,
                            padding: .init(top: 8, left: 8, bottom: 8, right: 0),
                            size: .init(width: 100, height: 100))
        
        
        // Add Heart button
        cardView.addSubview(heartButton)
        heartButton.anchor(trailing: cardView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 8),size: .init(width: 60, height: 60))
        heartButton.centerVertical(to: cardView)
        heartButton.addTarget(self, action: #selector(hearButtonTapped(_:)), for: .touchUpInside)
        
        // add track title
        cardView.addSubview(trackName)
        trackName.anchor(top: cardView.topAnchor, leading: artWorkImage.trailingAnchor, trailing: heartButton.leadingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 20))
        
        
        //add track genre
        cardView.addSubview(trackGenre)
        trackGenre.anchor(top: trackName.bottomAnchor, leading: artWorkImage.trailingAnchor, trailing: heartButton.leadingAnchor, padding: .init(top: 4, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 20))
        
        //add track price
        cardView.addSubview(trackPrice)
        trackPrice.anchor(top: trackGenre.bottomAnchor, leading: artWorkImage.trailingAnchor, trailing: heartButton.leadingAnchor, padding: .init(top: 4, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 20))
        
    }
    
    
    
    /// set Cell Data
    public func setUI(with model: TrackModel) {
        self.model = model
        
        //art work
        if let url = URL(string: model.artWorkUrl ?? "") {
            artWorkImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }
        
        // track name
        trackName.text = model.collectionName
        
        // genre
        trackGenre.text = model.genre ?? ""
        
        // price
        trackPrice.text = "\(model.currency ?? "") \(model.price)"
        
        // liked
        heartButton.setImageState(liked: model.isLiked)
    }
    
    
    /// Heart Tapped
    @objc func hearButtonTapped(_ button: HeartButton) {
        if let model = model {
            button.flipLikedState()
            model.isLiked = button.isLiked
            CoreDataManager.instance.update(trackModel: model)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//
//  TrackDetailsViewController.swift
//  Appetiser Code Challenge
//
//  Created by Ariel Dominic Cabanag on 2/5/22.
//

import Foundation
import AVKit
class TrackDetailsViewController: UIViewController {
    
    
    //MARK: [START] Public variables
    var model: TrackModel!
    var didTapLike:((_ model: TrackModel) ->())?
    //MARK: [END] Public variables to set
    
    
    //MARK: [START] Private UI variables
    private let heartButton: HeartButton = {
        let button = HeartButton()
        button.enableContraints()
        button.tintColor = .white
        button.enableContraints()
        return button
    }()
    
    private let avController: AVPlayerViewController = {
        let aVC = AVPlayerViewController()
        aVC.showsPlaybackControls = false
        return aVC
    }()
    
    private let trackName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.text = "Track Name"
        label.textColor = .white
        label.enableContraints()
        return label
    }()
    
    private let trackPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Track Price"
        label.textColor = .white
        label.enableContraints()
        return label
    }()
    
    private let trackDescription: UITextView = {
        let text = UITextView()
        text.font = UIFont.systemFont(ofSize: 15)
        text.text = "Track description"
        text.textColor = .white
        text.backgroundColor = .clear
        text.textContainer.lineFragmentPadding = 0;
        text.enableContraints()
        return text
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .clear
        view.spacing = 0
        view.distribution = .fillProportionally
        view.axis = .vertical
        view.enableContraints()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        setData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.playVideo()
        }
    }
    //MARK: [END] Privte UI variables
    
    
    /// Create TrackDetailsViewController and set required variables
    /// - Parameter model: Model to use to populate TrackDetailsViewController
    class func create(model: TrackModel) -> TrackDetailsViewController
    {
        let vc = TrackDetailsViewController()
        vc.model = model
        return vc
    }
    
    
    /// Instantiate TrackDetailsViewController UI
    private func initUI() {
        
        // add player view
        self.view.addSubview(avController.view)
        avController.view.fill(parent: self.view)
        
        
        // add heart button
        self.view.addSubview(heartButton)
        heartButton.anchor(bottom: self.view.layoutMarginsGuide.bottomAnchor, trailing: self.view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 16),size: .init(width: 60, height: 60))
        heartButton.addTarget(self, action: #selector(hearButtonTapped(_:)), for: .touchUpInside)
        self.view.bringSubviewToFront(heartButton)
        

        //create stackview to contain details
        self.view.addSubview(stackView)
        stackView.anchor(top: nil, bottom: self.view.layoutMarginsGuide.bottomAnchor, leading: self.view.leadingAnchor, trailing: heartButton.leadingAnchor)
        
        // add track title
        stackView.addArrangedSubview(trackName)
        trackName.anchor(leading: stackView.leadingAnchor, trailing: stackView.trailingAnchor, size: .init(width: 0, height: 20))
        // add release date
        stackView.addArrangedSubview(trackPrice)
        trackPrice.anchor(leading: stackView.leadingAnchor, trailing: stackView.trailingAnchor, size: .init(width: 0, height: 20))
        
        // add long description
        stackView.addArrangedSubview(trackDescription)
        trackDescription.anchor(leading: stackView.leadingAnchor, trailing: stackView.trailingAnchor, size: .init(width: 0, height: 100))
    }
    
    /// Set TrackDetailsViewController setData
    private func setData() {
        // liked
        heartButton.setImageState(liked: model.isLiked)
        
        // track name
        trackName.text = model.collectionName
        
        // price
        trackPrice.text = "\(model.currency ?? "") \(model.price)"
        
        // description
        trackDescription.text = model.longDescription
    }
    
    /// Triggered when heart button is tapped
    @objc func hearButtonTapped(_ button: HeartButton) {
        button.flipLikedState() // flip button state
        model.isLiked = button.isLiked // set model isLiked status.
        CoreDataManager.instance.update(trackModel: model) // update in saved model in device
        
        //Note: updates TracklistViewController model
        if let didTapLike = didTapLike {
            didTapLike(model)
        }
    }
    
    //Plays video/audio
    private func playVideo() {
        guard let url = URL(string: model.previewUrl) else { return }

        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        avController.player = AVPlayer(url: url)

        // play the video
        avController.player?.play()
    }
}

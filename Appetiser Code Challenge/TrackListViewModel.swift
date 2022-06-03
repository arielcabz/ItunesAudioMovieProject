//
//  TrackViewModel.swift
//  Appetiser Code Challenge
//
//  Created by Ariel Dominic Cabanag on 2/5/22.
//

import Foundation
import RxSwift
import RxCocoa
class TrackListViewModel {
    let searchText = PublishSubject<String>()
    private var _startLoading = BehaviorRelay<Bool>(value: true)
    private var _stopLoading = BehaviorRelay<Bool>(value: false)
    var _allTracks = BehaviorRelay<[TrackModel]>(value: [])
    var _showTracks = BehaviorRelay<[TrackModel]>(value: [])
    var disposeBag = DisposeBag()
    
    var startLoading: Driver<Bool> {
        return self._startLoading.asDriver()
    }
    
    var stopLoading: Driver<Bool> {
        return self._stopLoading.asDriver()
    }
    
    public func getTrackList() {
        if ApiManager.instance.hasDetectedConnection {
            _startLoading.accept(true)
            ApiManager.instance.getTrackList().subscribe(onNext: { [weak self] data in
                if let wSelf = self {
                    wSelf._stopLoading.accept(true)
                    // fetch liked tracks
                    let likedTracks = CoreDataManager.instance.fetchLikedTracks()
                    let fetchedTracks = data.results
                    for id in likedTracks {
                        let tracks = fetchedTracks.filter {
                            $0.id == id
                        }
                        if let track = tracks.first {
                            track.isLiked = true
                        }
                    }
                    wSelf._allTracks.accept(fetchedTracks)
                    wSelf._showTracks.accept(fetchedTracks)
                    CoreDataManager.instance.save(tracklist: fetchedTracks)
                }
            }, onError: { [weak self] error in
                guard let wSelf = self else { return }
                wSelf._stopLoading.accept(true)
                // do nothing
            }).disposed(by: self.disposeBag)
        } else {
            // fetch from core data
            let trackList = CoreDataManager.instance.fetchTrackList()
            self._allTracks.accept(trackList)
            self._showTracks.accept(trackList)
        }
    }
    
    func filterTracksByQuery(searchText: String) {
        if searchText.isEmpty {
            _showTracks.accept(_allTracks.value)
        } else {
            // bag probably needs to be reset here
            _allTracks.asObservable()
                .map { // map: apply a transformation to $0
                // The desired transformation of $0 is to remove track that do not contain query
                    $0.filter { $0.collectionName.contains(searchText) }
                }.bind(to: _showTracks).disposed(by: disposeBag)
        }
    }
    
    
    func update(trackModel: TrackModel) {
        //update listsßß∫
        var allTrackList = _allTracks.value
        for (index,model) in allTrackList.enumerated() {
            if model.id == trackModel.id {
                allTrackList[index] = trackModel
                _allTracks.accept(allTrackList)
            }
        }
        
        var showTracksList = _showTracks.value
        for (index,model) in showTracksList.enumerated() {
            if model.id == trackModel.id {
                showTracksList[index] = trackModel
                _showTracks.accept(showTracksList)
            }
        }
    }
    
}

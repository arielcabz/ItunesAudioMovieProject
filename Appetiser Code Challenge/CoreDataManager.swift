//
//  CoreDataManager.swift
//  Appetiser Code Challenge
//
//  Created by Ariel Dominic Cabanag on 2/6/22.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let instance = CoreDataManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    /// Saves tracklist in device memory
    /// - Parameter tracklist: A list of TrackModels fetched from API
    public func save(tracklist: [TrackModel]) {
        // [1] delete all data
        self.deleteAllData(in: "Track")
        
        // [2]save fetched from API
        self.appDelegate.persistentContainer.performBackgroundTask({ context in
            let entityDesc = NSEntityDescription.entity(forEntityName: "Track", in: context)
            for trackModel in tracklist {
                guard let entity = entityDesc else { return }
                let trackObj = Track(entity: entity, insertInto: context)
                trackObj.artWorkUrl = trackModel.artWorkUrl
                trackObj.longDescription = trackModel.longDescription
                trackObj.currency = trackModel.currency
                trackObj.price = trackModel.price
                trackObj.id = Int64(trackModel.id)
                trackObj.collectionName = trackModel.collectionName
                trackObj.releaseDate = trackModel.releaseDate
                trackObj.primaryGenreName = trackModel.genre
                trackObj.isLiked = trackModel.isLiked
                do {
                    try context.save()
                } catch _ as NSError {
                    // TODO: handle the error
                }
            }
        })
    }
    
    /// Delete saved track list in device memory
    /// - Parameter entity: Entity Name
    private func deleteAllData(in entity: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Track")
        do {
            let tracks = try context.fetch(fetchRequest)
            for track in tracks {
                context.delete(track as! NSManagedObject)
            }
            try context.save()
        } catch _ as NSError{
            // TODO: handle the error
        }
    }
    
    
    /// Update saved track in device memory
    /// - Parameter trackModel: Updated trackModel
    public func update(trackModel: TrackModel) {
        if trackModel.isLiked {
            addLikeTrack(trackModel.id)
        } else {
            removeLikeTrack(trackModel.id)
        }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Track")
        let predicate = NSPredicate(format: "id ==\(trackModel.id)")
        fetchRequest.predicate = predicate
        do {
            let tracks =  try context.fetch(fetchRequest) as! [Track]
            for track in tracks {
                track.isLiked = trackModel.isLiked
                try context.save()
                return
            }
        } catch _ as NSError{
            // TODO: handle the error
        }
    }
    
    
    /// Fetch saved track list in device memory
    /// - RETURNS: A list of track models
    public func fetchTrackList() -> [TrackModel] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var tracks = [Track]()
        let fetchRequest = Track.fetchRequest()
        do {
            tracks = try context.fetch(fetchRequest)
        } catch _ as NSError{
            // TODO: handle the error
        }
        
        // Convert Track to TrackModel
        var trackList = [TrackModel]()
        for track in tracks {
            let trackModel = TrackModel()
            trackModel.artWorkUrl = track.artWorkUrl
            trackModel.longDescription = track.longDescription
            trackModel.currency = track.currency
            trackModel.price = track.price
            trackModel.id = Int(track.id)
            trackModel.collectionName = track.collectionName ?? ""
            trackModel.releaseDate = track.releaseDate
            trackModel.genre = track.primaryGenreName
            trackModel.isLiked = track.isLiked
            trackModel.previewUrl = track.previewUrl ?? ""
            trackList.append(trackModel)
        }
        return trackList
    }
    
    
    /// Fetch liked track list in device memory
    /// - RETURNS: A list of ids
    public func fetchLikedTracks() -> [Int] {
        var likedTrackIds = [Int]()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = LikedTrack.fetchRequest()
        do {
            let likedTracks = try context.fetch(fetchRequest)
            for likedTrack in likedTracks {
                likedTrackIds.append(Int(likedTrack.id))
            }
        } catch _ as NSError{
            // TODO: handle the error
        }
        return likedTrackIds
    }
    
    
    /// Fetch liked track list in device memory
    /// - Parameter tracklist: A list of TrackModels fetched from API
    /// - RETURNS: A list of ids
    private func checkForDuplicate(id: Int) -> Bool {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = LikedTrack.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id ==\(id)")
        do {
            let likedTracks = try context.fetch(fetchRequest)
            return likedTracks.isEmpty
        } catch _ as NSError{
            // TODO: handle the error
        }
        return false
    }
    
    /// Remove liked track from device memory
    /// - Parameter id: ID of the liked track
    private func removeLikeTrack(_ id: Int) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = LikedTrack.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id ==\(id)")
        do {
            let likedTracks = try context.fetch(fetchRequest)
            for item in likedTracks {
                context.delete(item)
            }
            try context.save()
        } catch _ as NSError{
            // TODO: handle the error
        }
    }
    
    /// Remove liked track from device memory
    /// - Parameter id: ID of the liked track
    private func addLikeTrack(_ id: Int) {
        if checkForDuplicate(id: id) { // add liked track if no duplicate
            addLikeTrack(id)
        } else {
            return
        }
        
        // add track id into save liked list
        self.appDelegate.persistentContainer.performBackgroundTask({ context in
            let entityDesc = NSEntityDescription.entity(forEntityName: "LikedTrack", in: context)
            guard let entity = entityDesc else { return }
            let trackObj = LikedTrack(entity: entity, insertInto: context)
            trackObj.id = Int64(id)
            do {
                try context.save()
            } catch _ as NSError {
                // TODO: handle the error
            }
        })
    }
   
}

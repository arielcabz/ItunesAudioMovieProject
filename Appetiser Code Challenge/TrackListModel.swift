//
//  TrackListModel.swift
//  Appetiser Code Challenge
//
//  Created by Ariel Dominic Cabanag on 2/5/22.
//

import Foundation
import ObjectMapper



/// Track List Model
/// Mappable
/// Struct vs Class type -  Class models are refence types why struct isn't
/// This model will contain the API response
class TrackListModel: Mappable {
    required init?(map: Map) {}
    func mapping(map: Map) {
        resultCount <- map["resultCount"]
        results <- map["results"]
    }
    var resultCount: Int = 0
    var results = [TrackModel]()
}

/// Track Model
/// Mappable
/// Struct vs Class type -  Class models are refence types why struct isn't
/// This model will contain  the track data from API response or from save data from device (Core Data)
class TrackModel: Mappable {
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        genre <- map["primaryGenreName"]
        id <- map["trackId"]
        collectionName <- map["collectionName"]
        longDescription <- map["longDescription"]
        price <- map["collectionPrice"]
        currency <- map["currency"]
        releaseDate <- map["releaseDate"]
        artWorkUrl <- map["artworkUrl100"]
        trackName <- map["trackName"]
        previewUrl <- map["previewUrl"]
        
        // for movie tracks
        if !trackName.isEmpty {
            collectionName = trackName
        }
        
        // for audio books
        if id == 0 { //
            id <- map["artistId"]
        }
        // for audio books description
        if longDescription == nil {
            longDescription <- map["description"]
            longDescription = longDescription?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        }
    }
    
    
    init() {}
    
    var id: Int = 0
    var collectionName: String = ""
    var longDescription: String?
    var price: Double = 0.0
    var currency: String?
    var genre: String?
    var releaseDate: String?
    var trackName: String = ""
    var artWorkUrl: String?
    var isLiked: Bool = false
    var previewUrl = ""
}

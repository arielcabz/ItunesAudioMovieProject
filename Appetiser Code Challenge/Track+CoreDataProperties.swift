//
//  Track+CoreDataProperties.swift
//  
//
//  Created by Ariel Dominic Cabanag on 2/6/22.
//
//

import Foundation
import CoreData


extension Track {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Track> {
        return NSFetchRequest<Track>(entityName: "Track")
    }

    @NSManaged public var artWorkUrl: String?
    @NSManaged public var longDescription: String?
    @NSManaged public var currency: String?
    @NSManaged public var price: Double
    @NSManaged public var id: Int64
    @NSManaged public var collectionName: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var isLiked: Bool
    @NSManaged public var primaryGenreName: String?
    @NSManaged public var previewUrl: String?
}

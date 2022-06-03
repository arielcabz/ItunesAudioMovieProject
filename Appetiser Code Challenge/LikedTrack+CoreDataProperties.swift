//
//  LikedTrack+CoreDataProperties.swift
//  
//
//  Created by Ariel Dominic Cabanag on 2/6/22.
//
//

import Foundation
import CoreData


extension LikedTrack {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LikedTrack> {
        return NSFetchRequest<LikedTrack>(entityName: "LikedTrack")
    }

    @NSManaged public var id: Int64

}

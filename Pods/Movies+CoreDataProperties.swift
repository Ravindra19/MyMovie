//
//  Movies+CoreDataProperties.swift
//  My Movie
//
//  Created by Ravindra Gaikwad on 02/07/24.
//
//

import Foundation
import CoreData


extension Movies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movies> {
        return NSFetchRequest<Movies>(entityName: "Movies")
    }

    @NSManaged public var id: String?
    @NSManaged public var thumb: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var descriptions: String?
    @NSManaged public var lastPlayed: Int64

}

extension Movies : Identifiable {

}

//
//  Entity+CoreDataProperties.swift
//  CoreDataPhotos
//
//  Created by Brady Webb on 10/25/19.
//  Copyright © 2019 Brady Webb. All rights reserved.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var body: String?
    @NSManaged public var rawAddData: Date?
    @NSManaged public var rawImage: Data?
    @NSManaged public var title: String?

}

//
//  Zametka+CoreDataProperties.swift
//  Zametki
//
//  Created by ADMIMN on 09.07.2021.
//
//

import Foundation
import CoreData


extension Zametka {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Zametka> {
        return NSFetchRequest<Zametka>(entityName: "Zametka")
    }

    @NSManaged public var contentBody: String?
    @NSManaged public var contentTitle: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var group: NSSet?

}

// MARK: Generated accessors for group
extension Zametka {

    @objc(addGroupObject:)
    @NSManaged public func addToGroup(_ value: Group)

    @objc(removeGroupObject:)
    @NSManaged public func removeFromGroup(_ value: Group)

    @objc(addGroup:)
    @NSManaged public func addToGroup(_ values: NSSet)

    @objc(removeGroup:)
    @NSManaged public func removeFromGroup(_ values: NSSet)

}

extension Zametka : Identifiable {

}

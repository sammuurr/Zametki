//
//  Group+CoreDataProperties.swift
//  Zametki
//
//  Created by ADMIMN on 09.07.2021.
//
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var zametki: NSSet?

}

// MARK: Generated accessors for zametki
extension Group {

    @objc(addZametkiObject:)
    @NSManaged public func addToZametki(_ value: Zametka)

    @objc(removeZametkiObject:)
    @NSManaged public func removeFromZametki(_ value: Zametka)

    @objc(addZametki:)
    @NSManaged public func addToZametki(_ values: NSSet)

    @objc(removeZametki:)
    @NSManaged public func removeFromZametki(_ values: NSSet)

}

extension Group : Identifiable {

}

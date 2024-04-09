//
//  File+CoreDataProperties.swift
//  My IP Port
//
//  Created by Henri Petuker on 7/2/22.
//
//  Autogenerated Class by Core Data. Changed attributes to non optional (how bad is this?)
//
//  Since this is an autogenerated file I disabled SwiftLint Errors of type missing_docs
// swiftlint:disable missing_docs

import Foundation
import CoreData


extension File {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<File> {
        return NSFetchRequest<File>(entityName: "File")
    }
    
    @NSManaged public var applicant: String
    @NSManaged public var brandClass: String
    @NSManaged public var caseStatus: String
    @NSManaged public var changeDate: Date
    @NSManaged public var clientSymbol: String
    @NSManaged public var country: String
    @NSManaged public var creationDate: Date
    @NSManaged public var currentState: String
    @NSManaged public var entryDate: Date // Verändert von Date?
    @NSManaged public var entryNb: String?
    @NSManaged public var familySymbol: String?
    @NSManaged public var id: String
    @NSManaged public var image: Data // Verändert von Data?
    @NSManaged public var imageDesign: Data // NEU (auch in xcdata datei hinzugefügt)
    @NSManaged public var issueDate: Date
    @NSManaged public var issueNb: String
    @NSManaged public var matterType: String
    @NSManaged public var onlineRegister: URL?
    @NSManaged public var publishDate: Date
    @NSManaged public var publishNb: String
    @NSManaged public var registrationDate: Date
    @NSManaged public var registrationNb: String
    @NSManaged public var title: String
    @NSManaged public var family: FileFamily?
    @NSManaged public var inventors: NSSet
    @NSManaged public var productClasses: NSSet
    @NSManaged public var products: NSSet
}

// MARK: Generated accessors for inventors
extension File {
    @objc(addInventorsObject:)
    @NSManaged public func addToInventors(_ value: StringCD)

    @objc(removeInventorsObject:)
    @NSManaged public func removeFromInventors(_ value: StringCD)

    @objc(addInventors:)
    @NSManaged public func addToInventors(_ values: NSSet)

    @objc(removeInventors:)
    @NSManaged public func removeFromInventors(_ values: NSSet)
}

// MARK: Generated accessors for productClasses
extension File {
    @objc(addProductClassesObject:)
    @NSManaged public func addToProductClasses(_ value: StringCD)

    @objc(removeProductClassesObject:)
    @NSManaged public func removeFromProductClasses(_ value: StringCD)

    @objc(addProductClasses:)
    @NSManaged public func addToProductClasses(_ values: NSSet)

    @objc(removeProductClasses:)
    @NSManaged public func removeFromProductClasses(_ values: NSSet)
}

// MARK: Generated accessors for products
extension File {
    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: StringCD)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: StringCD)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)
}

extension File: Identifiable {
}
// swiftlint:enable missing_docs

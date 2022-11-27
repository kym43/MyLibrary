//
//  BookInfo+CoreDataProperties.swift
//  MyLibrary
//
//  Created by Ken Tai on 2022/11/25.
//
//

import Foundation
import CoreData


extension BookInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookInfo> {
        return NSFetchRequest<BookInfo>(entityName: "BookInfo")
    }

    @NSManaged public var uuid: Int64
    @NSManaged public var isFavorite: Bool
    @NSManaged public var author: String?
    @NSManaged public var publisher: String?
    @NSManaged public var publishDate: String?
    @NSManaged public var coverUrl: String?
    @NSManaged public var title: String?

}

extension BookInfo : Identifiable {

}

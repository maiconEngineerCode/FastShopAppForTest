//
//  Product+CoreDataProperties.swift
//  FastShopForTest
//
//  Created by ACT on 03/06/23.
//
//

import Foundation
import CoreData


extension ProductHQObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductHQObject> {
        return NSFetchRequest<ProductHQObject>(entityName: "ProductHQ")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String
    
    @nonobjc func saveProductHQ(name: String,container: PersistentContainer) {
        self.name = name
        container.saveContext(backgroundContext: self.managedObjectContext)
    }
    
    @nonobjc func fetchProducts(container: PersistentContainer) throws -> [ProductHQObject] {
        let items = try container.viewContext.fetch(ProductHQObject.fetchRequest())
        return items
    }

}

extension ProductHQObject : Identifiable {

}

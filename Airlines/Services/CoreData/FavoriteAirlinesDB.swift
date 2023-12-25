//
//  FavoriteAirlinesDB.swift
//  Airlines
//
//  Created by Khater on 25/12/2023.
//

import Foundation
import CoreData

/// This Class handles operations for add, delete, retreive Favorite Airlines from CoreData
class FavoriteAirlinesDB: FavoriteAirlinesDBProtocol {
    private enum Attributes: String {
        case name
        case phone
        case logoURL
        case site
        case entityName = "Airline"
        case databaseName = "Airlines"
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Attributes.databaseName.rawValue)
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Couldn't read data model: \(error)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    private var records: [Airline: NSManagedObject] = [:]
    var favoriteAirlines: [Airline] { records.map({ $0.key }) }
    
    private func convert(_ managedObject: NSManagedObject) -> Airline? {
        guard
            let name = managedObject.value(forKey: Attributes.name.rawValue) as? String,
            let phone = managedObject.value(forKey: Attributes.phone.rawValue) as? String,
            let logoURL = managedObject.value(forKey: Attributes.logoURL.rawValue) as? String,
            let site = managedObject.value(forKey: Attributes.site.rawValue) as? String
        else { return nil }
        return Airline(name: name, phone: phone, logoURL: logoURL, site: site)
    }
    
    func fetch() {
        let request = NSFetchRequest<NSManagedObject>(entityName: Attributes.entityName.rawValue)
        guard let objcets = try? context.fetch(request) else { return }
        records.removeAll()
        for object in objcets {
            if let airline = convert(object){
                records[airline] = object
            }
        }
    }
    
    func save(_ airline: Airline) {
        let managedObject = NSEntityDescription.insertNewObject(forEntityName: Attributes.entityName.rawValue, into: context)
        managedObject.setValue(airline.name, forKey: Attributes.name.rawValue)
        managedObject.setValue(airline.phone, forKey: Attributes.phone.rawValue)
        managedObject.setValue(airline.logoURL, forKey: Attributes.logoURL.rawValue)
        managedObject.setValue(airline.site, forKey: Attributes.site.rawValue)
        try? context.save()
        records[airline] = managedObject
        fetch()
    }
    
    func delete(_ airline: Airline) {
        if let managedObject = records[airline] {
            context.delete(managedObject)
            fetch()
        }
    }
}

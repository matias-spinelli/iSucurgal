//
//  DataController.swift
//  iSucurgal
//
//  Created by Matías Spinelli on 05/12/2025.
//

import CoreData

final class DataController {

    static let shared = DataController()

    let container: NSPersistentContainer

    var context: NSManagedObjectContext { container.viewContext }

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "iSucurgal")

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Error al cargar Core Data: \(error), \(error.userInfo)")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func saveContext() throws {
        let ctx = container.viewContext
        if ctx.hasChanges {
            try ctx.save()
        }
    }
}

extension DataController {
    static var preview: DataController = {
        let controller = DataController(inMemory: true)
        return controller
    }()
}

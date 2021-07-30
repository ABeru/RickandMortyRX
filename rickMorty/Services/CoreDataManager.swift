//
//  CoreDataManager.swift
//  rickMorty
//
//  Created by Alexandre on 12.07.21.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static func addFavoriteMovie(charName: String, charId: String) {
        let context = AppDelegate.coreDataContainer.viewContext
        let eDescription = NSEntityDescription.entity(forEntityName: "CharEntity", in: context)
        let charAndId = CharEntity(entity: eDescription!, insertInto: context)
        charAndId.charName = charName
        charAndId.charId = charId
        
        do {
            try context.save()
        } catch {
        }
    }
    static func fetchChar() -> [CharEntity] {
      let context = AppDelegate.coreDataContainer.viewContext
      let request: NSFetchRequest<CharEntity> = CharEntity.fetchRequest()
      do {
        let char = try context.fetch(request)
        let chars = char as [CharEntity]
          return chars
      } catch {
          print("ERROR: Couldn’t fetch results")
      }
      return []
    }

}

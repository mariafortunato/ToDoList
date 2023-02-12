import CoreData
import UIKit

class DataController {
    var context: NSManagedObjectContext?
    
    init() {
        context = (UIApplication.shared.delegate as? AppDelegate)?
            .persistentContainer
            .viewContext
    }
    
    func saveAnnotation(title: String, description: String, hour: Double, context: NSManagedObjectContext) {
        let notes = Notes(context: context)
        
        notes.id = UUID()
        notes.title = title
        notes.descriptionNote = description
        notes.hour = hour
        
        save(context: context)
    }
}

private extension DataController {
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            
        }
    }
}

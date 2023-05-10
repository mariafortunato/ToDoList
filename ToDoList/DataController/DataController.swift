import CoreData
import UIKit

class DataController {
    var context: NSManagedObjectContext?
    
    init() {
        context = (UIApplication.shared.delegate as? AppDelegate)?
            .persistentContainer
            .viewContext
    }
    
    func saveAnnotation(model: AnnotationModel, context: NSManagedObjectContext) {
        let notes = Notes(context: context)
        
        notes.id = UUID()
        notes.title = model.title
        notes.descriptionNote = model.descriptionNote
        notes.hour = model.hour
        
        save(context: context)
    }
    
    func editAnnotation(annotationOld: Notes, titleNew: String, descriptionNew: String, context: NSManagedObjectContext) {
        
        annotationOld.title = titleNew
        annotationOld.descriptionNote = descriptionNew
        annotationOld.hour = Date()
        
        save(context: context)
    }
}

private extension DataController {
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Erro ao salvar")
        }
    }
}

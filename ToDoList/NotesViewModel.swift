import CoreData

protocol NotesViewModelProtocol {
    var fetchedResult: NSFetchedResultsController<Notes>? { get }
    var countCells: Int { get }
    
    func loadNotes()
    func createCell(indexPath: IndexPath) -> Annotation
}

struct Annotation {
    var title: String
    var descriptionNote: String
    var hour: Double
    var id: UUID
}

class NotesViewModel {
    var fetchedResult = NSFetchedResultsController<Notes>()
    let dataController = DataController()
    
    init() {
        loadNotes()
    }
}

private extension NotesViewModel {
    func loadNotes() {
        guard let dataController = dataController.context else { return }
        let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResult = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResult.performFetch()
        } catch { }
    }
    
    func createCell(indexPath: IndexPath) -> Annotation {
        let notes = fetchedResult.fetchedObjects?[indexPath.row]
        
        let title = notes?.title ?? ""
        let descriptionNote = notes?.descriptionNote ?? ""
        let hour = notes?.hour ?? 0.0
        let id = notes?.id ?? UUID()
        
        
        
        return Annotation(title: title, descriptionNote: descriptionNote, hour: hour, id: id)
    }
    
    var countCells: Int {
        fetchedResult.fetchedObjects?.count ?? 0
    }
}

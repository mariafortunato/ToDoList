import CoreData

protocol NotesViewModelProtocol {
    var fetchedResult: NSFetchedResultsController<Notes> { get }
    
    func countCells() -> Int
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
    private let dataController = DataController()
    
    init() {
        loadNotes()
    }
}

extension NotesViewModel: NotesViewModelProtocol {
    func loadNotes() {
        guard let dataController = dataController.context else { return }
        let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResult = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResult.performFetch()
        } catch {
            print("erro")
        }
    }
    
    func createCell(indexPath: IndexPath) -> Annotation {
        let notes = fetchedResult.fetchedObjects?[indexPath.row]
        
        let title = notes?.title ?? ""
        let descriptionNote = notes?.descriptionNote ?? ""
        let hour = notes?.hour ?? 0.0
        let id = notes?.id ?? UUID()

        return Annotation(title: title, descriptionNote: descriptionNote, hour: hour, id: id)
    }
    
    func countCells() -> Int {
        fetchedResult.fetchedObjects?.count ?? 1
    }
}

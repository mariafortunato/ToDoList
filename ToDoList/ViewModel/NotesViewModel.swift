import CoreData

protocol NotesViewModelProtocol {
    var fetchedResult: NSFetchedResultsController<Notes> { get }
    var dataController: DataController { get }
    func countCells() -> Int
    func createCell(indexPath: IndexPath) -> Annotation
    func calcTimeSince(date: Date) -> String
}

struct Annotation {
    var title: String
    var descriptionNote: String
    var hour: Date
    var id: UUID
}

class NotesViewModel {
    var fetchedResult = NSFetchedResultsController<Notes>()
    let dataController = DataController()
    
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
        let hour = notes?.hour ?? Date()
        let id = notes?.id ?? UUID()
        
        print(notes?.hour)

        return Annotation(title: title, descriptionNote: descriptionNote, hour: hour, id: id)
    }
    
    func countCells() -> Int {
        fetchedResult.fetchedObjects?.count ?? 1
    }
    
    func calcTimeSince(date: Date) -> String {
        // quantos min se passaram da data de parametro até agora
        let minutes = Int(-date.timeIntervalSinceNow) / 60
        let hours = minutes / 60
        let day = hours / 24

        if minutes < 60 {
            return "\(minutes) minutos atrás"
        } else if (minutes >= 60 && minutes < 120) {
            return "\(hours) horas atrás"
        } else if (minutes >= 120 && hours < 48) {
            return "\(hours) horas atrás"
        } else {
            return "\(day) dias atrás"
        }
    }
}

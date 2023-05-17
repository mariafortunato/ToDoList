import CoreData

protocol NotesViewModelProtocol {
    var fetchedResult: NSFetchedResultsController<Notes> { get }
    var dataController: DataController { get }
    var delegate: NotesViewModelDelegate? { get set }
    func countCells() -> Int
    func createCell(indexPath: IndexPath) -> AnnotationModel
    func calcTimeSince(date: Date) -> String
}

protocol NotesViewModelDelegate: AnyObject {
    func reloadTableView()
    func passagemDeDados() -> Notes?
}

class NotesViewModel {
    var fetchedResult = NSFetchedResultsController<Notes>()
    let dataController = DataController()
    weak var delegate: NotesViewModelDelegate?
    
    init() {
        loadNotes()
    }
}

extension NotesViewModel: NotesViewModelProtocol {
    func loadNotes() {
        guard let dataController = dataController.context else { return }
        let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResult = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResult.performFetch()
        } catch {
            print("erro")
        }
    }
    
    func createCell(indexPath: IndexPath) -> AnnotationModel {
        let notes = fetchedResult.fetchedObjects?[indexPath.row]
        
        let title = notes?.title ?? ""
        let descriptionNote = notes?.descriptionNote ?? ""
        let hour = notes?.hour ?? Date()
        let id = notes?.id ?? UUID()
        
        return AnnotationModel(title: title, descriptionNote: descriptionNote, hour: hour, id: id)
    }
    
    func countCells() -> Int {
        fetchedResult.fetchedObjects?.count ?? 0
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
    
    func save(title: String, description: String, hour: Date) {
        let model = AnnotationModel(title: title, descriptionNote: description, hour: hour, id: UUID())
        guard let dataC = dataController.context else { return }
        
        dataController.saveAnnotation(model: model, context: dataC)
        
    }
    
    func edit(annotationOld: Notes, titleNew: String, descriptionNew: String) {
        
        guard let dataControllerContext = dataController.context else { return }
        dataController.editAnnotation(
            annotationOld: annotationOld,
            titleNew: titleNew,
            descriptionNew: descriptionNew,
            context: dataControllerContext
        )
    }
}

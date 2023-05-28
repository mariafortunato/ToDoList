import CoreData
import UIKit

protocol NotesViewModelProtocol {
//    var fetchedResult: NSFetchedResultsController<Notes> { get }
//    var dataController: DataController { get }
    var arrayNotes: [Notes] { get }
    var delegate: NotesViewModelDelegate? { get set }
    func loadNotes()
    func numberOfRows() -> Int
    func createCell(indexPath: IndexPath) -> AnnotationModel
    func calcTimeSince(date: Date) -> String
    func delete(annotation: Notes)
    func tableViewEmpty()
}

protocol NotesViewModelDelegate: AnyObject {
    func reloadData()
    func emptyAnimation()
    func removeAnimation()
//    func passagemDeDados() -> Notes?
}

final class NotesViewModel {
    private var fetchedResult = NSFetchedResultsController<Notes>()
    private let dataController: DataControllerProtocol
    var arrayNotes: [Notes] {
        guard let notes = fetchedResult.fetchedObjects else { return [] }
        return notes
    }
    weak var delegate: NotesViewModelDelegate?
    
    init(
        fetchedResult: NSFetchedResultsController<Notes> = NSFetchedResultsController<Notes>(),
        dataController: DataControllerProtocol = DataController()
    ) {
        self.fetchedResult = fetchedResult
        self.dataController = dataController
    }
}

extension NotesViewModel: NotesViewModelProtocol {
    func loadNotes() {
        guard let dataController = dataController.context else { return }
        let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        
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
        let date = notes?.date ?? Date()
        let id = notes?.id ?? UUID()
        
        return AnnotationModel(title: title, descriptionNote: descriptionNote, date: date, id: id)
    }
    
    func numberOfRows() -> Int {
        arrayNotes.count
    }
    
    func tableViewEmpty() {
        if arrayNotes.count == 0 {
            delegate?.emptyAnimation()
        } else {
            delegate?.removeAnimation()
        }
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
    
    func save(title: String, description: String, date: Date) throws {
        let model = AnnotationModel(title: title, descriptionNote: description, date: date, id: UUID())
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
    
    func delete(annotation: Notes) {
        dataController.context?.delete(annotation)
        do {
            try dataController.context?.save()
            delegate?.emptyAnimation()
        } catch {
            print(error)
        }
    }
}

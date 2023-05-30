import CoreData
import UIKit

protocol NotesViewModelProtocol {
    var fetchedResult: NSFetchedResultsController<Notes> { get }
    var dataController: DataController { get }
    var delegate: NotesViewModelDelegate? { get set }
    func loadNotes()
    func numberOfRows() -> Int
    func createCell(indexPath: IndexPath) -> AnnotationModel
    func calcTimeSince(date: Date) -> String
    func delete(annotation: Notes)
    func changeView()
    func openNoteViewController(model: Notes?)
}

protocol NotesViewModelDelegate: AnyObject {
    func reloadTableView()
    func displayAnimationView()
    func displayTableView()
}

class NotesViewModel {
    var fetchedResult = NSFetchedResultsController<Notes>()
    let dataController = DataController()
    
    private var notes: [Notes] {
        guard let notes = fetchedResult.fetchedObjects else { return [] }
        return notes
    }
    
    weak var delegate: NotesViewModelDelegate?
    weak var viewController: NotesViewController?
    
    init(
        viewController: NotesViewController,
        fetchedResult: NSFetchedResultsController<Notes> = NSFetchedResultsController<Notes>()
    ) {
        self.viewController = viewController
        self.fetchedResult = fetchedResult
        loadNotes()
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
            viewController?.showAlert(title: "Atenção", message: "Erro ao carregar a nota")
        }
    }
    
    func createCell(indexPath: IndexPath) -> AnnotationModel {
        let note = notes[indexPath.row]
        
        let title = note.title ?? ""
        let descriptionNote = note.descriptionNote ?? ""
        let date = note.date ?? Date()
        let id = note.id ?? UUID()
        
        return .init(title: title, descriptionNote: descriptionNote, date: date, id: id)
    }
    
    func numberOfRows() -> Int {
        notes.count
    }
    
    func changeView() {
        if notes.count == 0 {
            delegate?.displayAnimationView()
        } else {
            delegate?.displayTableView()
        }
        delegate?.reloadTableView()
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
    
    func delete(annotation: Notes) {
        dataController.context?.delete(annotation)
        do {
            try dataController.context?.save()
            delegate?.reloadTableView()
        } catch {
            viewController?.showAlert(title: "Atencao", message: "Erro ao deletar a nota")
        }
    }
    
    func openNoteViewController(model: Notes?) {
        let details = NoteViewController(model: model)
        viewController?.navigationController?.pushViewController(details, animated: true)
    }
}

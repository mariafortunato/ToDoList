import CoreData
import UIKit

protocol NoteViewModelProtocol {
    var dataController: DataController { get }
    func edit(annotationOld: Notes, titleNew: String, descriptionNew: String)
    func save(title: String, description: String, date: Date)
}

class NoteViewModel {
    let dataController = DataController()
    
    private let note: Notes?
    
    weak var delegate: NotesViewModelDelegate?
    weak var viewController: NoteViewController?
    
    init(
        viewController: NoteViewController,
        note: Notes? = nil
    ) {
        self.viewController = viewController
        self.note = note
    }
}

extension NoteViewModel: NoteViewModelProtocol {
    func edit(annotationOld: Notes, titleNew: String, descriptionNew: String) {
        guard let dataControllerContext = dataController.context else { return }
        dataController.editAnnotation(
            annotationOld: annotationOld,
            titleNew: titleNew,
            descriptionNew: descriptionNew,
            context: dataControllerContext
        )
    }
    
    func save(title: String, description: String, date: Date) {
        let model = AnnotationModel(title: title, descriptionNote: description, date: date, id: UUID())
        guard let dataC = dataController.context else { return }
        
        dataController.saveAnnotation(model: model, context: dataC)
    }
}

import CoreData
import UIKit

protocol NoteViewModelProtocol {
    var dataController: DataController { get }
    func edit(annotationOld: Notes, titleNew: String, descriptionNew: String)
    func save(title: String, description: String, date: Date)
    func returnToScreen()
    func buttonIsAdd(
        model: Notes?,
        titleTF: String?,
        descriptionTF: String?,
        buttonName: String?
    )
}

class NoteViewModel {
    let dataController = DataController()
    private let date = Date()
    
    private let note: Notes?
    
    weak var viewController: NoteViewController?
    
    init(
        viewController: NoteViewController?,
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
    
    func buttonIsAdd(
        model: Notes?,
        titleTF: String?,
        descriptionTF: String?,
        buttonName: String?
    ) {
        guard let titleTF = titleTF, titleTF != "", let descriptionTF = descriptionTF, descriptionTF != "" else {
            viewController?.showAlert(title: "Atenção", message: "Preencha todos os campos")
            return
        }
        guard let model = model else {
            save(title: titleTF, description: descriptionTF, date: date)
            return
        }
        edit(annotationOld: model, titleNew: titleTF, descriptionNew: descriptionTF)
    }
    
    func returnToScreen() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}

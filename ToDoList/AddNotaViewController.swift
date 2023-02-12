import UIKit
import CoreData

class AddNotaViewController: UIViewController {
    private lazy var titleNote: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Ir ao médico"
        textField.layer.borderWidth = 0.5
        
        return textField
    }()
    private lazy var descriptionNote: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Dia 12 às 11h"
        textField.backgroundColor = .cyan
        textField.layer.borderWidth = 0.5
        
        return textField
    }()
    private lazy var hour: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "16 horas atrás"
        textField.backgroundColor = .cyan
        textField.layer.borderWidth = 0.5
        
        return textField
    }()
    private lazy var buttonAdd: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Adicionar", for: .normal)
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(actionButtonAdd), for: .touchUpInside)
        
        return button
    }()
    
    var dataController: DataController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFunctions()
      
    }
}
private extension AddNotaViewController {
    func setupFunctions() {
        setupUI()
        setupComponents()
        setupConstraints()
    }
    
    func setupComponents() {
        view.addSubview(titleNote)
        view.addSubview(descriptionNote)
        view.addSubview(buttonAdd)
    }
    
    func setupConstraints() {
        titleNote.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.leading.equalTo(view).inset(32)
            make.height.equalTo(50)
        }
        
        descriptionNote.snp.makeConstraints { make in
            make.top.equalTo(titleNote.snp.bottom).offset(16)
            make.trailing.leading.equalTo(view).inset(32)
            make.height.equalTo(50)
        }
        
        buttonAdd.snp.makeConstraints { make in
            make.top.equalTo(descriptionNote.snp.bottom).offset(16)
            make.trailing.leading.equalTo(view).inset(32)
            make.height.equalTo(50)
        }
    }
    
    func setupUI() {
        view.backgroundColor = .white
    }
}

@objc
private extension AddNotaViewController {
    private func actionButtonAdd() {
        dataController?.saveAnnotation(title: titleNote.text ?? "", description: descriptionNote.text ?? "", hour: 0, context: dataController?.context ?? NSManagedObjectContext())
        navigationController?.popViewController(animated: false)
    }
}

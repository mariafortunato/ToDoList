import UIKit
import CoreData

class AddNotaViewController: UIViewController {
    private lazy var stackVertical: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 2
        [titleNote, descriptionNote].forEach { view in
            stack.addArrangedSubview(view)
        }
        
        return stack
    }()
    private lazy var titleNote: LabelAndTextFieldView = {
        let view = LabelAndTextFieldView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.label.text = "Título:"
        view.textField.placeholder = "Ir ao médico"
        return view
    }()
    private lazy var descriptionNote: LabelAndTextFieldView = {
        let view = LabelAndTextFieldView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.label.text = "Descrição:"
        view.textField.placeholder = "Dia 12/03 às 16h"
        return view
    }()
    private lazy var buttonAdd: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Adicionar", for: .normal)
        button.addTarget(self, action: #selector(actionButtonAdd), for: .touchUpInside)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    var dataController = DataController()
    
    
    
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
        view.addSubview(stackVertical)
        view.addSubview(buttonAdd)
    }
    
    func setupConstraints() {
        stackVertical.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.trailing.leading.equalTo(view).inset(32)
            make.bottom.equalTo(buttonAdd.snp.top).offset(-100)
        }
        buttonAdd.snp.makeConstraints { make in
            make.top.equalTo(stackVertical.snp.bottom).offset(100)
            make.leading.trailing.equalTo(view).inset(32)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
            make.height.equalTo(50)
        }
    }
    
    func setupUI() {
        view.backgroundColor = .white
    }

    func nextScreen(title: String, description: String) {
        let model = Annotation(title: title, descriptionNote: description, hour: 0, id: UUID())
        dataController.saveAnnotation(model: model, context: dataController.context ?? NSManagedObjectContext())
        
        navigationController?.popViewController(animated: false)
    }
}

@objc
private extension AddNotaViewController {
    private func actionButtonAdd() {
        guard let title = titleNote.textField.text,
              let description = descriptionNote.textField.text
        else { return }

        if title != "" || description != "" {
            nextScreen(title: title, description: description)
        } else {
            showAlert(title: "Atenção!", message: "Preencha todos os campos")
        }
    }
}

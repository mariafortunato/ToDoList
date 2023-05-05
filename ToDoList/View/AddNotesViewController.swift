import UIKit
import CoreData

class AddNotesViewController: UIViewController {
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
        view.label.textColor = UIColor(named: "Color574345")
        view.label.font = UIFont.systemFont(ofSize: 20)
        
        view.textField.placeholder = "Ir ao médico"
        view.textField.backgroundColor = .white
        return view
    }()
    private lazy var descriptionNote: LabelAndTextFieldView = {
        let view = LabelAndTextFieldView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.label.text = "Descrição:"
        view.label.textColor = UIColor(named: "Color574345")
        view.label.font = UIFont.systemFont(ofSize: 20)
        
        view.textField.placeholder = "Dia 12/03 às 16h"
        view.textField.backgroundColor = UIColor(named: "Colorf5eed4")
        return view
    }()
    private lazy var buttonAdd: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Adicionar", for: .normal)
        button.addTarget(self, action: #selector(actionButtonAdd), for: .touchUpInside)
        button.backgroundColor = UIColor(named: "Color574345")
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    var dataController = DataController()
    var date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFunctions()
        
    }
}
private extension AddNotesViewController {
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
            make.centerX.centerY.equalToSuperview()
            make.trailing.leading.equalTo(view).inset(32)
        }
        buttonAdd.snp.makeConstraints { make in
            make.top.equalTo(stackVertical.snp.bottom).offset(150)
            make.leading.trailing.equalTo(view).inset(32)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
            make.height.equalTo(50)
        }
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(named: "Colorf2ecdc")
    }

    func nextScreen(title: String, description: String, hour: Date) {
        let model = Annotation(title: title, descriptionNote: description, hour: hour, id: UUID())
        dataController.saveAnnotation(model: model, context: dataController.context ?? NSManagedObjectContext())
        
        navigationController?.popViewController(animated: false)
    }
}

@objc
private extension AddNotesViewController {
    private func actionButtonAdd() {
        guard let title = titleNote.textField.text,
              let description = descriptionNote.textField.text
        else { return }
        
        if title != "" && description != "" {
            nextScreen(title: title, description: description, hour: date)
            print(date)
        } else {
            showAlert(title: "Atenção!", message: "Preencha todos os campos")
        }
    }
}

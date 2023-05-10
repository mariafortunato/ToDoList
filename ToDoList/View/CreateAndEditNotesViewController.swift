import UIKit
import CoreData

class CreateAndEditNotesViewController: UIViewController {
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
        
        view.textField.placeholder = "Fazer compras"
        
        return view
    }()
    private lazy var descriptionNote: LabelAndTextFieldView = {
        let view = LabelAndTextFieldView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.label.text = "Descrição:"
        view.label.textColor = UIColor(named: "Color574345")
        view.label.font = UIFont.systemFont(ofSize: 20)
        
        view.textField.placeholder = "Arroz, feijão, frango, uva, laranja, manteiga"
        
        return view
    }()
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Button", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.backgroundColor = UIColor(named: "Color574345")
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    let viewModel = NotesViewModel()
    let hour = Date()
    let model: Notes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFunctions()
        setupScreen()
    }
    
    init(model: Notes? = nil) {
        
        self.model = model
        super.init(nibName: nil, bundle: nil)
        titleNote.textField.text = model?.title
        descriptionNote.textField.text = model?.descriptionNote
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CreateAndEditNotesViewController {
    
    func setupFunctions() {
        setupComponents()
        setupConstraints()
    }
 
    func setupComponents() {
        view.addSubview(stackVertical)
        view.addSubview(button)
    }
    
    func setupConstraints() {
        stackVertical.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.trailing.leading.equalTo(view).inset(32)
        }
        button.snp.makeConstraints { make in
            make.top.equalTo(stackVertical.snp.bottom).offset(100)
            make.leading.trailing.equalTo(view).inset(32)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
            make.height.equalTo(50)
        }
    }
    
    func setupUIEdit() {
        view.backgroundColor = UIColor(named: "Colorf2ecdc")
        title = "Editar anotação"
        button.setTitle("Editar", for: .normal)
    }
    
    func setupUIAdd() {
        view.backgroundColor = UIColor(named: "Colorf2ecdc")
        title = "Adicionar anotação"
        button.setTitle("Adicionar", for: .normal)
    }
    
    func setupScreen() {
        if titleNote.textField.text == "" {
            setupUIAdd()
        } else {
            setupUIEdit()
        }
    }
    
    func save(title: String, description: String, hour: Date) {
        viewModel.save(title: title, description: description, hour: hour)
    }
    
    func returnScreen() {
        navigationController?.popViewController(animated: false)
    }
}

@objc
private extension CreateAndEditNotesViewController {
    private func buttonAction() {
        if button.titleLabel?.text == "Adicionar" {
            guard let title = titleNote.textField.text,
                  let description = descriptionNote.textField.text
            else { return }
            if title == "" && description == "" {
                showAlert(title: "Atenção", message: "Preencha todos os campos")
            } else {
                viewModel.save(title: title, description: description, hour: hour)
            }
        } else {
            guard let title = titleNote.textField.text,
                  let description = descriptionNote.textField.text,
            let model = model
            else { return }
            viewModel.edit(annotationOld: model, titleNew: title, descriptionNew: description)
        }
        returnScreen()
        print("eee")
    }
}

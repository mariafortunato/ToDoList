import UIKit
import CoreData

class NoteViewController: UIViewController {
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
    
    private var viewModel: NoteViewModel?

    private let date = Date()
    private let model: Notes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFunctions()
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

extension NoteViewController {
    func setupFunctions() {
        configViewModel()
        setupScreen()
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
    
    func configViewModel() {
        viewModel = NoteViewModel(viewController: self)
        viewModel?.delegate = self
    }
    
    func UIEdit() {
        title = "Editar anotação"
        button.setTitle("Editar", for: .normal)
    }
    
    func UIAdd() {
        title = "Adicionar anotação"
        button.setTitle("Adicionar", for: .normal)
    }
    
    func setupScreen() {
        view.backgroundColor = UIColor(named: "Colorf2ecdc")
        viewModel?.screenPresent(text: titleNote.textField.text)
    }
    
    func save(title: String, description: String, date: Date) {
        viewModel?.save(title: title, description: description, date: date)
    }

}

@objc
private extension NoteViewController {
    private func buttonAction() {
        viewModel?.buttonIsAdd(
            model: model,
            titleTF: titleNote.textField.text,
            descriptionTF: descriptionNote.textField.text,
            buttonName: button.titleLabel?.text
        )
        viewModel?.returnToScreen()
    }
}

extension NoteViewController: NoteViewModelDelegate {
    func setupUIEdit() {
        UIEdit()
    }
    
    func setupUIAdd() {
        UIAdd()
    }
}

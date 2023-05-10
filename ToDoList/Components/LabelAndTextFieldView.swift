import UIKit

class LabelAndTextFieldView: UIView {
    private lazy var stackVertical: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 2
        [label, textField].forEach { view in
            stack.addArrangedSubview(view)
        }
        
        return stack
    }()
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.borderWidth = 1
        tf.leftView = UIView(frame: CGRectMake(0, 0, 15, 0))
        tf.leftViewMode = .always
        tf.layer.cornerRadius = 8
        tf.backgroundColor = UIColor(named: "Colorf5eed4")
        
        return tf
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFunctions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LabelAndTextFieldView {
    func setupFunctions() {
        setupUI()
        setupComponents()
        setupConstraints()
    }
    
    func setupComponents() {
        addSubview(stackVertical)
    }
    
    func setupConstraints() {
        stackVertical.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.trailing.leading.equalToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    func setupUI() {
        backgroundColor = .clear
    }
}

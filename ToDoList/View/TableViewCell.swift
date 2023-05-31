import UIKit

class TableViewCell: UITableViewCell {
    static let identifier = "CustomCell"
    
    private lazy var stackH: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        [stackV, hour].forEach { view in
            stack.addArrangedSubview(view)
        }
        return stack
    }()
    
    private lazy var stackV: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        
        [titleNote, descriptionNote].forEach { view in
            stack.addArrangedSubview(view)
        }
        return stack
    }()
    
    private(set) lazy var titleNote: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Médico"
        label.font = UIFont(name: "Arial Bold", size: 18)
        return label
    }()
    private lazy var descriptionNote: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dia 12 às 19h"
        label.textColor = .systemGray2
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    private lazy var hour: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "12 horas atras"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        label.textColor = .systemGray2
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupFunctions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInformations(model: AnnotationModel, hour: String) {
        titleNote.text = model.title
        descriptionNote.text = model.descriptionNote
        self.hour.text = hour
    }
}

private extension TableViewCell {
    func setupFunctions() {
        setupUI()
        setupComponents()
        setupConstraints()
    }
    
    func setupComponents() {
        addSubview(stackH)
    }
    
    func setupConstraints() {
        stackH.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    func setupUI() {
        backgroundColor = .white
    }
}

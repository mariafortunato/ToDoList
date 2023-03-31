import UIKit

class TableViewCell: UITableViewCell {
    static let identifier = "CustomCell"
    
    private(set) lazy var titleNote: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Médico"
        label.font = UIFont(name: "Arial Bold", size: 18)
        return label
    }()
    private lazy var descriptionNote: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dia 12 às 19h"
        label.textColor = .systemGray2
        return label
    }()
    private lazy var hour: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "12 horas atras"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupFunctions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInformations(model: Annotation) {
        titleNote.text = model.title
        descriptionNote.text = model.descriptionNote

    }
}

private extension TableViewCell {
    func setupFunctions() {
        setupComponents()
        setupConstraints()
    }
    
    func setupComponents() {
        addSubview(titleNote)
        addSubview(descriptionNote)
    }
    
    func setupConstraints() {
        titleNote.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview().inset(8)
        }
        
        descriptionNote.snp.makeConstraints { make in
            make.top.equalTo(titleNote.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview().inset(8)
        }
    }
}

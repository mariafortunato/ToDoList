import UIKit

class TableViewCell: UITableViewCell {
    static let identifier = "CustomCell"
    
    private lazy var titleNote: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private lazy var descriptionNote: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private lazy var hour: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
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
            make.top.bottom.leading.equalTo(contentView).inset(16)
            make.trailing.equalTo(descriptionNote.snp.leading).offset(-16)
        }
        
        descriptionNote.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(contentView).inset(-16)
        }
    }
}

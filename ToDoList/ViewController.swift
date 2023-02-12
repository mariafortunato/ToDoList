import SnapKit
import CoreData
import UIKit

class ViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(TableViewCell.self,
                       forCellReuseIdentifier: TableViewCell.identifier)
        return table
    }()
    
    var viewModel: NotesViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFunctions()
    }
}

private extension ViewController {
    func setupFunctions() {
        setupUI()
        setupComponents()
        setupConstraints()
        setupNavigation()
        configViewModel()
    }
    func configViewModel() {
        viewModel?.loadNotes()
        viewModel?.fetchedResult?.delegate = self
    }
    
    func setupComponents() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalTo(view)
        }
    }
    
    func setupUI() {
        view.backgroundColor = .white
    }
    
    func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addNote))
    }
}

@objc
extension ViewController {
    func addNote() {
        navigationController?.pushViewController(AddNotaViewController(), animated: false)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.countCells ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell,
              let model = viewModel?.createCell(indexPath: indexPath) else {
            return UITableViewCell()
        }
        
        cell.setupInformations(model: model)
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: NSFetchedResultsControllerDelegate {
    
}


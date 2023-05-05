import SnapKit
import CoreData
import UIKit

class ViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.register(TableViewCell.self,
                       forCellReuseIdentifier: TableViewCell.identifier)
        table.backgroundColor = UIColor(named: "Colorf2ecdc")
        return table
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(reloadView), for: .valueChanged)
        
        return refresh
    }()
    
    private let animationView = AnimationNoResultsView()
    private let viewModel: NotesViewModelProtocol = NotesViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = UIColor(named: "Color574345")
        reloadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFunctions()
    }
}

@objc
extension ViewController {
    private func reloadView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
}

private extension ViewController {
    func setupFunctions() {
        setupUI()
        configViewModel()
        setupComponents()
        setupConstraints()
        setupNavigation()
        countCells()
        setupRefreshControl()
    }
    
    func setupRefreshControl() {
        tableView.refreshControl = refreshControl
    }
    
    func configViewModel() {
        viewModel.fetchedResult.delegate = self
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
        view.backgroundColor = UIColor(named: "Colorf2ecdc")
    }
    
    func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addNote))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "Color574345")
    }
    
    func countCells() {
        if viewModel.countCells() == 0 {
            view = animationView
        }
    }
}

@objc
extension ViewController {
    func addNote() {
        navigationController?.pushViewController(AddNotesViewController(), animated: false)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.countCells()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        let model = viewModel.createCell(indexPath: indexPath)
        cell.setupInformations(model: model)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let eventArrayItem = viewModel.fetchedResult.fetchedObjects?[indexPath.row] else { return }
        if editingStyle == .delete {
            viewModel.dataController.context?.delete(eventArrayItem)
            print(eventArrayItem)
            do {
                try viewModel.dataController.context?.save()
            } catch {
                print(error)
            }
        }
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        switch type {
            case .delete:
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            default:
                tableView.reloadData()
        }
    } 
}


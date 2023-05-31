import SnapKit
import CoreData
import UIKit

class NotesViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.backgroundColor = UIColor(named: "Colorf2ecdc")
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(reloadTable), for: .valueChanged)
        refresh.tintColor = UIColor(named: "Colorffe6bd")
        
        return refresh
    }()
    
    private let animationView = AnimationNoResultsView()
    
    private var viewModel: NotesViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFunctions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = UIColor(named: "Color574345")
        viewModel.changeView()
    }
}

@objc
extension NotesViewController {
    private func reloadTable() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
}

private extension NotesViewController {
    func setupFunctions() {
        configViewModel()
        setupUI()
        setupNavigation()
        setupRefreshControl()
    }
    
    func setupRefreshControl() {
        tableView.refreshControl = refreshControl
    }
    
    func configViewModel() {
        viewModel = NotesViewModel(viewController: self)
        viewModel?.delegate = self
        viewModel?.fetchedResult.delegate = self
    }
    
    func setupTableView() {
        animationView.removeFromSuperview()
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalTo(view)
        }
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(named: "Colorf2ecdc")
    }
    
    func setupNavigation() {
        title = "Anotações"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addNote))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "Color574345")
    }
    
    func setupAnimationView() {
        tableView.removeFromSuperview()
        view.addSubview(animationView)
        
        animationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

@objc
extension NotesViewController {
    func addNote() {
        viewModel.openNoteViewController(model: nil)
    }
}

extension NotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        
        let model = viewModel.createCell(indexPath: indexPath)
        cell.setupInformations(model: model, hour: viewModel.calcTimeSince(date: model.date))
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let eventArrayItem = viewModel.fetchedResult.fetchedObjects?[indexPath.row] else { return }
        if editingStyle == .delete {
            viewModel?.delete(annotation: eventArrayItem)
            viewModel?.changeView()
        }
    }
}

extension NotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let note = viewModel?.fetchedResult.fetchedObjects?[indexPath.row] else { return }
        viewModel.openNoteViewController(model: note)
    }
}

extension NotesViewController: NSFetchedResultsControllerDelegate {
    
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

extension NotesViewController: NotesViewModelDelegate {
    func displayTableView() {
        setupTableView()
    }
    
    func displayAnimationView() {
        setupAnimationView()
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
}

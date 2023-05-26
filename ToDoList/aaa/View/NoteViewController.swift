import SnapKit
import CoreData
import UIKit

class NotesViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        table.backgroundColor = UIColor(named: "Colorf2ecdc")
        return table
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(tableViewReloadData), for: .valueChanged)
        refresh.tintColor = UIColor(named: "Colorffe6bd")
        
        return refresh
    }()
    
    private lazy var animationView = AnimationNoResultsView()
    
    private var viewModel: NotesViewModelProtocol = NotesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFunctions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = UIColor(named: "Color574345")
        viewModel.changeAnimationView()
    }
}

@objc
extension NotesViewController {
    private func tableViewReloadData() {
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
        setupComponents()
        setupConstraints()
        setupNavigation()
        setupRefreshControl()
    }
    
    func setupRefreshControl() {
        tableView.refreshControl = refreshControl
    }
    
    func configViewModel() {
        viewModel.loadNotes()
        viewModel.delegate = self
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
        title = "Anotações"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addNote))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "Color574345")
    }
    
    func setupViewAnimation() {
        view.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

@objc
extension NotesViewController {
    func addNote() {
        navigationController?.pushViewController(NotesViewController(), animated: false)
    }
}

extension NotesViewController: NotesViewModelDelegate {
    func reloadData() {
        tableView.reloadData()
    }
    
    func emptyAnimation() {
        setupViewAnimation()
    }
    
    func removeAnimation() {
        animationView.removeFromSuperview()
        tableView.reloadData()
    }
}

extension NotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        
        let model = viewModel.createCell(indexPath: indexPath)
        cell.setupInformations(model: model)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let eventArrayItem = viewModel.arrayNotes[indexPath.row]
        if editingStyle == .delete {
            viewModel.delete(annotation: eventArrayItem)
        }
    }
}

extension NotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let note = viewModel.arrayNotes[indexPath.row]
//        let details = NoteViewController(model: note)
//        navigationController?.pushViewController(details, animated: true)
    }
}

//extension NotesViewController: NSFetchedResultsControllerDelegate {
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        guard let indexPath = indexPath else { return }
//        switch type {
//            case .delete:
//                self.tableView.deleteRows(at: [indexPath], with: .fade)
//            default:
//                tableView.reloadData()
//        }
//    }
//}


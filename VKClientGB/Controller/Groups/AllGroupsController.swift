import UIKit
import RealmSwift

class AllGroupsController: UITableViewController {

    // MARK: - Variables
    var groups = [AllGroup]()
//    var groupProtocol = [BaseGroupProtocol]()
//    var myGroup2 = [Group]()
    let searchController = UISearchController(searchResultsController: nil)
    private var timer: Timer?
    private let imageService = ImageService()
    private let enterSearchLabel: UILabel = {
        let label = UILabel()
        label.text = "Пожалуйста введите в поле поиска название группы..."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    // MARK: - Controller lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
        setupSearchBar()
    }
    
    // MARK: - Private functions
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(AllGroupsCell.self, forCellReuseIdentifier: AllGroupsCell.cellId)
        tableView.addSubview(enterSearchLabel)
        enterSearchLabel.anchor(top: tableView.topAnchor, leading: tableView.leadingAnchor, bottom: nil, trailing: tableView.trailingAnchor, padding: .init(top: 100, left: 20, bottom: 0, right: 20), size: .init(width: tableView.frame.width - 40, height: 100))
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Enter group name"
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.backgroundColor : UIColor.white]
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
}

// MARK: - Table view data source and delegate
extension AllGroupsController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        enterSearchLabel.isHidden = groups.count != 0
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AllGroupsCell.cellId, for: indexPath) as? AllGroupsCell else {
            fatalError("Can not load group cell")
        }
        
        let group = groups[indexPath.row]
        cell.setupCell(group: group, by: imageService)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let myGroup = groups[indexPath.row]
        try! RealmService.save(items: [myGroup])
        
        searchController.isActive = false
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension AllGroupsController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            guard !searchText.isEmpty else {
                self.groups.removeAll()
                self.tableView.reloadData()
                return
            }
            
            AllGroupsRequest.fetchAllGroups(searchText: searchText) { [weak self] groups in
                guard let self = self else { return }
                self.groups = groups.response.items.filter({ (group) -> Bool in
                    return group.name.lowercased().contains(searchText.lowercased())
                })
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        groups.removeAll()
        tableView.reloadData()
    }
}

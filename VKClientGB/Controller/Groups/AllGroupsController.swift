import UIKit

class AllGroupsController: UITableViewController {

    // MARK: - Variables
    var groups = [Group]()
    let searchController = UISearchController(searchResultsController: nil)
    private let imageService = ImageService()
    
    // MARK: - Controller lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        tableView.tableFooterView = UIView()
        setupSearchBar()
    }
    
    // MARK: - Private functions
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Enter group name"
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Все группы"
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
    }
}

// MARK: - Table view data source and delegate

extension AllGroupsController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupsCell.cellId, for: indexPath) as? GroupsCell else {
            fatalError("Can not load group cell")
        }
        
        let group = groups[indexPath.row]
        cell.setupCell(group: group, by: imageService)
        
        return cell
    }
}



// MARK: - UISearchBarDelegate
extension AllGroupsController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        guard !searchText.isEmpty else {
            groups.removeAll()
            tableView.reloadData()
            return
        }

        AllGroupsRequest.fetchAllGroups(searchText: searchText) { [weak self] groups in
            
            self?.groups = groups.response.items.filter({ (group) -> Bool in
                return group.name.lowercased().contains(searchText.lowercased())
            })
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        groups.removeAll()
        tableView.reloadData()
    }
}

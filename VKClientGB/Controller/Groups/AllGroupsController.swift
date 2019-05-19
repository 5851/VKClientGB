import UIKit

class AllGroupsController: UITableViewController {

    // MARK: - Variables
    var groups = [Group]()
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Controller lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Все группы"
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

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupsCell.cellId, for: indexPath) as? GroupsCell else {
            fatalError("Can not load group cell")
        }
        
        let group = groups[indexPath.row]
        cell.group = group
        
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

        AlamofireService.shared.fetchAllGroups(searchText: searchText) { [weak self] groups in

            self?.groups = groups.filter({ (group) -> Bool in
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

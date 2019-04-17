import UIKit

class AllGroupsController: UITableViewController {

    // MARK: - Variables
    var groups = [
        Group(name: "Группа № 1", iconImage: UIImage(named: "garden")),
        Group(name: "Группа № 2", iconImage: UIImage(named: "garden")),
        Group(name: "Группа № 3", iconImage: UIImage(named: "garden")),
        Group(name: "Группа № 4", iconImage: UIImage(named: "garden")),
        Group(name: "Группа № 5", iconImage: UIImage(named: "garden")),
        Group(name: "Группа № 6", iconImage: UIImage(named: "garden")),
        Group(name: "Группа № 7", iconImage: UIImage(named: "garden")),
        Group(name: "Группа № 8", iconImage: UIImage(named: "garden")),
        Group(name: "Группа № 9", iconImage: UIImage(named: "garden")),
        Group(name: "Группа № 10", iconImage: UIImage(named: "garden")),
    ]
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredGroup = [Group]()
    
    // MARK: - Controller lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Все группы"
        tableView.tableFooterView = UIView()
        filteredGroup = groups
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
        return filteredGroup.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupsCell.cellId, for: indexPath) as? GroupsCell else {
            fatalError("Can not load group cell")
        }
        
        let group = filteredGroup[indexPath.row]
        cell.group = group
        
        return cell
    }
}

    // MARK: - UISearchBarDelegate
extension AllGroupsController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredGroup = groups
        } else {
            filteredGroup = self.groups.filter({ (group) -> Bool in
                return group.name.lowercased().contains(searchText.lowercased())
            })
        }
        tableView.reloadData()
    }
}

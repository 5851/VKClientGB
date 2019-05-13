import UIKit

class MyFriendsController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var alphabetView: UIView!
    
    // MARK: - Variables
    var friends = [Friend]()
    var filteredFriends = [Friend]()
    
    let searchController = UISearchController(searchResultsController: nil)

    var sectionsName = [Character]()
    var friendDictionary = [Character: [Friend]]()
    
    var buttons: [UIButton] = []
    var filteredButtons: [UIButton] = []
    
    // MARK: - Controller lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        friends = FriendsDataBase.shared.friends
        (sectionsName, friendDictionary) = sortFriends(friends: friends)
        filteredButtons = buttons
        
        setupSearchBar()
        setupTableView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchController.isActive = false
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotos",
            let photosController = segue.destination as? PhotosFriendController,
            let indexPath = tableView.indexPathForSelectedRow {
                let friendKey = sectionsName[indexPath.section]
                if let friendValues = friendDictionary[friendKey] {
                    photosController.photos = friendValues[indexPath.row].photos
                }
        }
    }
    
    // MARK: - Private functions
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Enter friend name"
        searchController.searchBar.searchBarStyle = .minimal
    }
    
    private func setupTableView() {
        tableView.delegate = self
        navigationItem.title = "Мои друзья"
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
    
    private func sortFriends(friends: [Friend]) -> (sectionsName: [Character], friendDictionary: [Character: [Friend]]) {
        
        var sectionsName = [Character]()
        var friendDictionary = [Character: [Friend]]()
        
        for friend in friends {
            guard let sectionName = friend.name.first else {
                continue
            }
            if friendDictionary[sectionName] != nil {
                friendDictionary[sectionName]!.append(friend)
            } else {
                friendDictionary[sectionName] = [friend]
            }
        }
        
        sectionsName = Array(friendDictionary.keys.sorted())
        
        return (sectionsName, friendDictionary)
    }
    
//    private func setupStackViewButtons(sectionsName: [Character]) {
//        for item in sectionsName {
//            buttons.append(createButton(for: String(item)))
//        }
//        let stackView = UIStackView(arrangedSubviews: buttons)
//        stackView.axis = .vertical
//        stackView.spacing = -5
//        alphabetView.addSubview(stackView)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.centerYAnchor.constraint(equalTo: alphabetView.centerYAnchor).isActive = true
//        stackView.centerXAnchor.constraint(equalTo: alphabetView.centerXAnchor).isActive = true
//    }
//
//    private func createButton(for entry: String) -> UIButton {
//        let button = UIButton(type: .system)
//        button.setTitle(entry, for: .normal)
//        button.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
//        button.addTarget(self, action: #selector(handleTapButton), for: .touchUpInside)
//        return button
//    }
    
//    @objc private func handleTapButton(sender: UIButton) {
//        guard let tag = buttons.lastIndex(of: sender) else { return }
//        guard let index = sectionsName.lastIndex(of: ((sender.titleLabel!.text!))) else { return }
//        if tag == index {
//            tableView.scrollToRow(at: IndexPath(row: 0, section: tag), at: .top, animated: true)
//        }
//    }
}

extension MyFriendsController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let letter = sectionsName[section]
        guard let friends = friendDictionary[letter] else { return 0 }
        return friends.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsName.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(sectionsName[section])
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0 ? 0: 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyFriendsCell.cellId, for: indexPath) as? MyFriendsCell else {
            fatalError("Can not load group cell")
        }
        
        let letter = sectionsName[indexPath.section]
        guard let users = friendDictionary[letter] else { return UITableViewCell() }
        let friend = users[indexPath.row]
        
        cell.friend = friend
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.backgroundView?.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {

        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var sections = [String]()
        for char in sectionsName {
            sections.append(String(char))
        }
        return sections
    }
}

// MARK: - UISearchBarDelegate
extension MyFriendsController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            (sectionsName, friendDictionary) = sortFriends(friends: friends)
            tableView.reloadData()
            return
        }

        let filteredFriends = friends.filter({ (friend) -> Bool in
            return friend.name.lowercased().contains(searchText.lowercased())
        })
        
        (sectionsName, friendDictionary) = sortFriends(friends: filteredFriends)
       
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        (sectionsName, friendDictionary) = sortFriends(friends: friends)
        tableView.reloadData()
    }
}

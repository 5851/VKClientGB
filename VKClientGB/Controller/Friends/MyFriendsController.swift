import UIKit

class MyFriendsController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var alphabetView: UIView!
    
    // MARK: - Variables
    private var friends = [Friend]()
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredFriendsDictionary = [String: [Friend]]()
    var filteredFriends = [Friend]()
    var filteredSection = [Character]()
    
    var sectionsName = [String]()
    var friendDictionary = [String: [Friend]]()
    var buttons: [UIButton] = []
    var filteredButtons: [UIButton] = []
    
    // MARK: - Controller lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        friends = FriendsDataBase.shared.friends
        filteredFriends = friends
        
        setupSearchBar()
        setupTableView()
        setupAlphabetControl()
        
        filteredFriendsDictionary = friendDictionary
        filteredButtons = buttons
        
        setupStackViewButtons()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchController.isActive = false
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let friendKey = sectionsName[section]
        if let friendValues = filteredFriendsDictionary[friendKey] {
            return friendValues.count
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsName.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsName[section]
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0 ? 0: 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyFriendsCell.cellId, for: indexPath) as? MyFriendsCell else {
            fatalError("Can not load group cell")
        }
        
        let friendKey = sectionsName[indexPath.section]
        if let friendValues = filteredFriendsDictionary[friendKey] {
            cell.nameFriend.text = friendValues[indexPath.row].name
            cell.iconFriend.image = friendValues[indexPath.row].iconImage
        }
        
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotos",
            let photosController = segue.destination as? PhotosFriendController,
            let indexPath = tableView.indexPathForSelectedRow {
                let friendKey = sectionsName[indexPath.section]
                if let friendValues = filteredFriendsDictionary[friendKey] {
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
    
    private func setupAlphabetControl() {
        for friend in friends {
            let friendKey = String(friend.name.prefix(1))
            if var friendValues = friendDictionary[friendKey] {
                friendValues.append(friend)
                friendDictionary[friendKey] = friendValues
            } else {
                friendDictionary[friendKey] = [friend]
             }
        }
        sectionsName = [String](friendDictionary.keys)
        sectionsName = sectionsName.sorted { $0 < $01 }
    }
    
    private func setupStackViewButtons() {
        for item in sectionsName {
            filteredButtons.append(createButton(for: item))
        }
        let stackView = UIStackView(arrangedSubviews: filteredButtons)
        stackView.axis = .vertical
        stackView.spacing = -5
        
        alphabetView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: alphabetView.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: alphabetView.centerXAnchor).isActive = true
    }
    
    private func createButton(for entry: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(entry, for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(handleTapButton), for: .touchUpInside)
        return button
    }
    
    @objc private func handleTapButton(sender: UIButton) {
        guard let tag = buttons.lastIndex(of: sender) else { return }
        guard let index = sectionsName.lastIndex(of: (sender.titleLabel?.text)!) else { return }
        if tag == index {
            tableView.scrollToRow(at: IndexPath(row: 0, section: tag), at: .top, animated: true)
        }
    }
}

// MARK: - UISearchBarDelegate
extension MyFriendsController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchController.searchBar.text == "" {
            filteredFriendsDictionary = friendDictionary
        } else {
            filteredFriendsDictionary.removeAll()
            
            for (_, value) in filteredFriendsDictionary {
                filteredFriends += value
            }
            let namesFilteredArray = filteredFriends.filter { $0.name.lowercased().contains(searchController.searchBar.text!.lowercased())}
            
            for filteredName in namesFilteredArray {
                if let letter = filteredName.name.first {
                    if filteredFriendsDictionary[String(letter)] != nil {
                        filteredFriendsDictionary[String(letter)]?.append(filteredName)
                    } else {
                        filteredFriendsDictionary[String(letter)] = [filteredName]
                    }
                }
            }
        }
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredFriendsDictionary = friendDictionary
        tableView.reloadData()
    }
}

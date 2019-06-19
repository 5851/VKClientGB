import UIKit
import RealmSwift

class MyFriendsController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var alphabetView: UIView!
    
    // MARK: - Variables
    var friendsRealm: Results<Friend> = try! RealmService.get(Friend.self)
    private var friendsToken: NotificationToken?

    var filteredFriends = [Friend]()
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Controller lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
        AlamofireService.shared.fetchFrieds { friends in
            try! RealmService.save(items: friends)
            self.filteredFriends = Array(self.friendsRealm)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        filteredFriends = Array(friendsRealm)
        
        friendsToken = friendsRealm.observe { [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                break
            case .update:
                self.tableView.reloadData()
            case .error(let error):
                print(error)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchController.isActive = false
        friendsToken?.invalidate()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotos",
            let photosController = segue.destination as? PhotosFriendController,
            let indexPath = tableView.indexPathForSelectedRow {
            print(friendsRealm[indexPath.row].id)
            photosController.friendId = friendsRealm[indexPath.row].id
        }
    }
    
    // MARK: - Private functions
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
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
}

extension MyFriendsController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyFriendsCell.cellId, for: indexPath) as? MyFriendsCell else {
            fatalError("Can not load group cell")
        }

        let friend = filteredFriends[indexPath.row]
        cell.setupCell(friend: friend)
        
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
}

// MARK: - UISearchBarDelegate
extension MyFriendsController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        guard !searchText.isEmpty else {
            filteredFriends = Array(friendsRealm)
            tableView.reloadData()
            return
        }

        filteredFriends = Array(friendsRealm).filter({ (friend) -> Bool in
            return friend.last_name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredFriends = Array(friendsRealm)
        tableView.reloadData()
    }
}

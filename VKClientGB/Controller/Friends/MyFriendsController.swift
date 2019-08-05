import UIKit
import RealmSwift
import PromiseKit
import Alamofire

class MyFriendsController: UITableViewController {

    // MARK: - Outlets
//    var tableView: UITableView!
    var alphabetView: UIView!
    
    // MARK: - Variables
    var friendsRealm: Results<Profile> = try! RealmService.get(Profile.self)
    private var friendsToken: NotificationToken?
    private let imageService = ImageService()

//    var filteredFriends = [Friend]()
    let searchController = UISearchController(searchResultsController: nil)
    
    private var firstLetters = [Character]()
    private var sortedFriends = [Character: Results<Profile>]()
    private var searchedFriends = [Profile]()
    
    // MARK: - Controller lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupTableView()
        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        FriendsListRequest.fetchFriends { friends in
//            try! RealmService.save(items: friends)
//            self.firstLetters = self.sort(self.friendsRealm)
//            self.tableView.reloadData()
//        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        FriendsListRequest.fetchFriendsWithPromiseKit()
            .done { [weak self] profiles in
                guard let self = self else { return }
                try! RealmService.save(items: profiles)
                self.firstLetters = self.sort(self.friendsRealm)
                self.tableView.reloadData()
            }.catch { error in
                print(error)
            }.finally {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
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
            let letter = String(firstLetters[indexPath.section])
            let sectionFriends: Results<Profile> = {
                if let searchText = searchController.searchBar.text,
                    !searchText.isEmpty {
                    return friendsRealm
                        .filter("last_name BEGINSWITH %@", letter)
                        .filter("last_name CONTAINS[cd] %@ OR first_name CONTAINS[cd] %@", searchText, searchText)
                    
                } else {
                    return friendsRealm.filter("last_name BEGINSWITH %@", letter)
                }
            }()
            photosController.friendId = sectionFriends[indexPath.row].id
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
        searchController.searchBar.backgroundColor = .white
    }
    
    private func setupTableView() {
        tableView.register(MyFriendsCell.self, forCellReuseIdentifier: MyFriendsCell.cellId)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.backgroundColor : UIColor.white]
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
    }
    
    private func sort(_ friends: Results<Profile>) -> [Character] {
        
        var firstLetters = [Character]()
        
        for friend in friends {
            guard let firstLetter = friend.last_name.first else { continue }
            
            if !firstLetters.contains(firstLetter) {
                firstLetters.append(firstLetter)
            }
        }
        
        return firstLetters.sorted()
    }
}

extension MyFriendsController {
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photosController = PhotosFriendController()
        let letter = String(firstLetters[indexPath.section])
        let sectionFriends: Results<Profile> = {
            if let searchText = searchController.searchBar.text,
                !searchText.isEmpty {
                return friendsRealm
                    .filter("last_name BEGINSWITH %@", letter)
                    .filter("last_name CONTAINS[cd] %@ OR first_name CONTAINS[cd] %@", searchText, searchText)
                
            } else {
                return friendsRealm.filter("last_name BEGINSWITH %@", letter)
            }
        }()
        photosController.friendId = sectionFriends[indexPath.row].id
        present(CustomNavigationController(rootViewController: photosController), animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return firstLetters.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(firstLetters[section])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let letter = String(firstLetters[section])
        let predicate = NSPredicate(format: "last_name BEGINSWITH %@", letter)
        if let searchText = searchController.searchBar.text,
            !searchText.isEmpty {
            let sectionFriends = friendsRealm.filter(predicate).filter("last_name CONTAINS[cd] %@ OR first_name CONTAINS[cd] %@", searchText, searchText)
            
            return sectionFriends.count
        } else {
            let sectionFriends = friendsRealm.filter(predicate)
            return sectionFriends.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyFriendsCell.cellId, for: indexPath) as? MyFriendsCell else {
            fatalError("Can not load group cell")
        }

        let letter = String(firstLetters[indexPath.section])
        
        let sectionFriends: Results<Profile> = {
            if let searchText = searchController.searchBar.text,
                !searchText.isEmpty {
                return friendsRealm
                    .filter("last_name BEGINSWITH %@", letter)
                    .filter("last_name CONTAINS[cd] %@ OR first_name CONTAINS[cd] %@", searchText, searchText)
                
            } else {
                return friendsRealm.filter("last_name BEGINSWITH %@", letter)
            }
        }()
        
        let friend = sectionFriends[indexPath.row]
        cell.setupCell(friend: friend, by: imageService)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.backgroundView?.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let b = firstLetters.map {String($0)}
        return b
    }
}

// MARK: - UISearchBarDelegate
extension MyFriendsController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.count == 0 {
            searchedFriends = Array(friendsRealm)
            firstLetters = sort(self.friendsRealm)
            tableView.reloadData()
        } else {
            let filteredFriends = self.friendsRealm.filter("last_name CONTAINS[cd] %@ OR first_name CONTAINS[cd] %@", searchText, searchText)
            
            firstLetters = sort(filteredFriends)
            
            tableView.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchedFriends = Array(friendsRealm)
        tableView.reloadData()
    }
}

import UIKit
import RealmSwift
import Alamofire

class MyGroupsController: UIViewController {

    // MARK: - Variables
    var groups: Results<Group> = try! RealmService.get(Group.self).sorted(byKeyPath: "name")
    var groupsToken: NotificationToken?
    private let imageService = ImageService()
    private let queque: OperationQueue = {
        let queque = OperationQueue()
        return queque
    }()
    private let searchController = UISearchController(searchResultsController: nil)
    private var timer: Timer?
    private let tableView = UITableView()
    private var refreshedControl: UIRefreshControl? = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()

    // MARK: - Controller lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupTableView()
        setupSearchBar()
        setupContstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMyGroups()
    }
    
    // MARK: - Private fucntions
    private func fetchMyGroups() {
        
        let url = ParametersVK.vkApi + ParametersVK.vkApiGroups

        let requestMyGroups = Alamofire.request(url, method: .get, parameters: ParametersVK.myGroupsParameters).validate()
        let fetchDataOperation = MyGroupsFetchDataOperation(request: requestMyGroups)
        queque.addOperation(fetchDataOperation)
        
        let parseDataOperation = MyGroupsParseDataOperation()
        parseDataOperation.addDependency(fetchDataOperation)
        queque.addOperation(parseDataOperation)
        
        let persistOperation = MyGroupsPersistOperation()
        persistOperation.addDependency(parseDataOperation)
        queque.addOperation(persistOperation)
        
        let displayOPeration = MyGroupDisplayOperation(controller: self)
        displayOPeration.addDependency(persistOperation)
        OperationQueue.main.addOperation(displayOPeration)
    }
    
    private func setupContstraints() {
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    private func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.register(MyGroupsCell.self, forCellReuseIdentifier: MyGroupsCell.cellId)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGroup))
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.backgroundColor : UIColor.white]
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        guard let refreshedControl = refreshedControl else { return }
        tableView.addSubview(refreshedControl)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Enter group name"
        searchController.searchBar.isTranslucent = false
    }
    
    func reloadTable(results: Results<Group>) {
        groups = results.sorted(byKeyPath: "name")
        tableView.reloadData()
    }
    
    @objc private func  refresh() {
        fetchMyGroups()
        refreshedControl?.endRefreshing()
    }
    
    // MARK: - Navigation
    @objc private func addGroup() {
        let allGroupsController = AllGroupsController()
        allGroupsController.navigationItem.title = "Все группы"
        navigationController?.pushViewController(allGroupsController, animated: true)
    }
}

// MARK: - Table view data source and delegate
extension MyGroupsController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyGroupsCell.cellId, for: indexPath) as? MyGroupsCell else {
            fatalError("Can not load group cell")
        }
        
        let group = groups[indexPath.row]
        cell.setupCell(group: group, by: imageService)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! RealmService.delete(items: [groups[indexPath.row]])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = GroupDetailController()
        controller.navigationItem.title = groups[indexPath.row].name
        controller.group = groups[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension MyGroupsController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            if searchText.count == 0 {
                self.groups = try! RealmService.get(Group.self).sorted(byKeyPath: "name")
                self.tableView.reloadData()
                return
            } else {
                let filteredGroups = self.groups.filter("name CONTAINS[cd] %@", searchText)
                self.groups = filteredGroups
                self.tableView.reloadData()
            }
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        groups = try! RealmService.get(Group.self).sorted(byKeyPath: "name")
        tableView.reloadData()
    }
}

import UIKit
import RealmSwift
import Alamofire

class MyGroupsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Variables
    var groups: Results<Group> = try! RealmService.get(Group.self).sorted(byKeyPath: "name")
    private var groupsToken: NotificationToken?
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Controller lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchAndUpdateData()
//        fetchMyGroups()
        setupTableView()
        navigationItem.title = "Мои группы"
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupsCell.cellId, for: indexPath) as? GroupsCell else {
            fatalError("Can not load group cell")
        }
        
        let group = groups[indexPath.row]
        cell.group = group
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! RealmService.delete(items: [groups[indexPath.row]])
        }
    }
    
    // MARK: - Private fucntions
    
    private func fetchAndUpdateData() {
        AlamofireService.shared.fetchMyGroups()
        
        groupsToken = groups._observe({ [weak tableView] changes in
            guard let tableView = tableView else { return }
            
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let updates):
                tableView.applyChanges(deletions: deletions, insertions: insertions, updates: updates)
            case .error:
                break
            }
        })
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.delegate = self
    }
    
    func fetchMyGroups() {
        
        let url = "https://api.vk.com/method/groups.get"
        
        let parameters: Parameters = [
            "user_id": Session.shared.userId,
            "access_token": Session.shared.token,
            //            "fields": "description,members_count",
            "extended": 1,
            "v": "5.95"
        ]
        
        let queque: OperationQueue = {
            let queque = OperationQueue()
            queque.qualityOfService = .userInteractive
            return queque
        }()
        let request1 = Alamofire.request(url, method: .get, parameters: parameters).validate()
        let getDataOperation = GetDataOperation(request: request1)
        queque.addOperation(getDataOperation)
        let parseData = ParseData()
        parseData.addDependency(getDataOperation)
        queque.addOperation(parseData)
        
        let reloadTableController = RealodTableController(controller: self)
        reloadTableController.addDependency(parseData)
        OperationQueue.main.addOperation(reloadTableController)
    }
    
    // MARK: - Navigation
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier  == "addGroup" {
            if let allGroups = segue.source as? AllGroupsController,
                let indexPath = allGroups.tableView.indexPathForSelectedRow {

                let myGroup = allGroups.groups[indexPath.row]
                
                
                guard !(groups.contains(where: { group -> Bool in
                    return group.name == myGroup.name
                })) else { return }

                try! RealmService.save(items: [myGroup])
            }
        }
    }
}

import UIKit
import RealmSwift
import Alamofire

class MyGroupsController: UIViewController {

    // MARK: - Variables
    var groups: Results<Group> = try! RealmService.get(Group.self).sorted(byKeyPath: "name")
    var groupsToken: NotificationToken?
    private let queque: OperationQueue = {
        let queque = OperationQueue()
        return queque
    }()
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Controller lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchMyGroups()
        navigationItem.title = "Мои группы"
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Private fucntions
    
    func fetchMyGroups() {
        
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
        displayOPeration.addDependency(parseDataOperation)
        OperationQueue.main.addOperation(displayOPeration)
        
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

// MARK: - Table view data source and delegate

extension MyGroupsController: UITableViewDataSource, UITableViewDelegate {

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
}

import UIKit
import RealmSwift

class MyGroupsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Variables
    var groups: Results<Group>? = {
        return realm.objects(Group.self).sorted(byKeyPath: "name")
    }()
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Controller lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
        
        navigationItem.title = "Мои группы"
        tableView.tableFooterView = UIView()
        tableView.delegate = self
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupsCell.cellId, for: indexPath) as? GroupsCell else {
            fatalError("Can not load group cell")
        }
        
        let group = groups?[indexPath.row]
        cell.group = group
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            RealmService.shared.deleteGroups([groups![indexPath.row]])
            tableView.reloadData()
        }
    }
    
    // MARK: - Private fucntions
    
    private func fetchData() {        
        AlamofireService.shared.fetchMyGroups { [weak self] in
            
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Navigation
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier  == "addGroup" {
            if let allGroups = segue.source as? AllGroupsController,
                let indexPath = allGroups.tableView.indexPathForSelectedRow {

                let myGroup = allGroups.groups[indexPath.row]            
                guard !(groups?.contains(where: { group -> Bool in
                    return group.name == myGroup.name
                }))! else { return }

                RealmService.shared.addGroupFromAllGroups([myGroup])
                tableView.reloadData()
            }
        }
    }
}

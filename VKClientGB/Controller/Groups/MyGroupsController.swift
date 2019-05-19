import UIKit

class MyGroupsController: UITableViewController {

    // MARK: - Variables
    var groups = [Group]()
    
    // MARK: - Controller lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        
        navigationItem.title = "Мои группы"
        tableView.tableFooterView = UIView()
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Private fucntions
    
    private func fetchData() {
        AlamofireService.shared.fetchMyGroups { [weak self] groups in
            self?.groups = groups
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Navigation
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier  == "addGroup" {
            if let allGroups = segue.source as? AllGroupsController,
                let indexPath = allGroups.tableView.indexPathForSelectedRow {
                
                let myGroup = allGroups.groups[indexPath.row]
                let newIndexPath = IndexPath(item: groups.count, section: 0)
                
                guard !groups.contains(where: { group -> Bool in
                    return group.name == myGroup.name
                }) else { return }
             
                groups.append(myGroup)
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        }
    }
}

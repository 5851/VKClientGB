import UIKit

class AllGroupsController: UITableViewController {

    let cellIdentifier = "allGroupsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Все группы"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = "Все группы"
        
        return cell
    }
}

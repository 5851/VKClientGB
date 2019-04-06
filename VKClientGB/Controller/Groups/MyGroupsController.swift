import UIKit

class MyGroupsController: UITableViewController {

    let cellIdentifier = "myGroupsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Мои группы"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = "Мои группы"
        
        return cell
    }
}

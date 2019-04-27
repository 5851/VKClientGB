import UIKit

class FeedsController: UITableViewController {

    // MARK: - Variables
    var feeds = [Feed]()

    // MARK: - Controller lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        feeds = FriendsDataBase.shared.feeds
        navigationItem.title = "Новости"
        setupTableView()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedsCell.cellId, for: indexPath) as? FeedsCell else {
            fatalError("Can not load feed cell")
        }
        let feed = feeds[indexPath.row]
        cell.feed = feed
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //MARK: - private functions    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "FeedsCell", bundle: nil), forCellReuseIdentifier: FeedsCell.cellId)
        tableView.estimatedRowHeight = 500
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
}

import UIKit

class MyFriendsController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Variables
    @IBOutlet weak var tableView: UITableView!
    
    private var friends = [
        Friend(name: "Иванов Иван Иванович", iconImage: UIImage(named: "friend"),photos: [
                UIImage(named: "friend"),
                UIImage(named: "friend"),
                UIImage(named: "friend"),
                UIImage(named: "friend"),
            ]),
        Friend(name: "Петров Петр Петрович", iconImage: UIImage(named: "friend"), photos: [
                UIImage(named: "friend2"),
                UIImage(named: "friend2"),
                UIImage(named: "friend2"),
                UIImage(named: "friend2"),
                ]),
        Friend(name: "Александров Сидор Сидорович", iconImage: UIImage(named: "friend"), photos: [
                UIImage(named: "friend3"),
                UIImage(named: "friend3"),
                UIImage(named: "friend3"),
                UIImage(named: "friend3"),
                ]),
        Friend(name: "Борисов Семен Семенович", iconImage: UIImage(named: "friend"), photos: [
                UIImage(named: "friend4"),
                UIImage(named: "friend4"),
                UIImage(named: "friend4"),
                UIImage(named: "friend4"),
                ]),
        Friend(name: "Сергеев Сергей Сергеевич", iconImage: UIImage(named: "friend"), photos: [
                UIImage(named: "friend5"),
                UIImage(named: "friend5"),
                UIImage(named: "friend5"),
                UIImage(named: "friend5"),
                ]),
    ]
    
    @IBOutlet weak var alphabetView: UIView!
    @IBOutlet weak var alphabetLabel: UILabel!
    
    var sectionsName = [String]()
    var friendsMassive = [[Friend]]()
    
    // MARK: - Controller lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupAlphabetControl()
     }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsName.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsName[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyFriendsCell.cellId, for: indexPath) as? MyFriendsCell else {
            fatalError("Can not load group cell")
        }
        
        let friend = friends[indexPath.row]
        cell.friend = friend
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotos",
            let photosController = segue.destination as? PhotosFriendController,
            let indexPath = tableView.indexPathForSelectedRow {

            photosController.photos = friends[indexPath.row].photos
        }
    }
    
    // MARK: - Private functions
    
    private func setupTableView() {
        tableView.delegate = self
        navigationItem.title = "Мои друзья"
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
    
    private func setupAlphabetControl() {
        friends.forEach { (friend) in
            let word = friend.name
            if let letter = word.first {
                if !sectionsName.contains(String(letter)) {
                    sectionsName.append(String(letter))
                }
            }
        }
        let alphabetSorted = sectionsName.sorted { $0 < $01 }
        alphabetLabel.text = "\(alphabetSorted.joined(separator: "\n"))"
    }
}

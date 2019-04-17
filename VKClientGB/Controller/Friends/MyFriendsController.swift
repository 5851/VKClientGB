import UIKit

class MyFriendsController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var alphabetView: UIView!
    
    // MARK: - Variables
    private var friends = [Friend]()
    
    var sectionsName = [String]()
    var friendDictionary = [String: [Friend]]()
    var buttons: [UIButton] = []
    
    // MARK: - Controller lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friends = FriendsDataBase.shared.friends
        
        setupTableView()
        setupAlphabetControl()
        setupStackViewButtons()
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let friendKey = sectionsName[section]
        if let friendValues = friendDictionary[friendKey] {
            return friendValues.count
        }
        return 0
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
        
        let friendKey = sectionsName[indexPath.section]
        if let friendValues = friendDictionary[friendKey] {
            cell.nameFriend.text = friendValues[indexPath.row].name
            cell.iconFriend.image = friendValues[indexPath.row].iconImage
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotos",
            let photosController = segue.destination as? PhotosFriendController,
            let indexPath = tableView.indexPathForSelectedRow {
                let friendKey = sectionsName[indexPath.section]
                if let friendValues = friendDictionary[friendKey] {
                    photosController.photos = friendValues[indexPath.row].photos
                }
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
        sectionsName = sectionsName.sorted { $0 < $01 }
        
        for friend in friends {
            let friendKey = String(friend.name.prefix(1))
            if var friendValues = friendDictionary[friendKey] {
                friendValues.append(friend)
                friendDictionary[friendKey] = friendValues
            } else {
                friendDictionary[friendKey] = [friend]
             }
        }
    }
    
    private func setupStackViewButtons() {
        for item in sectionsName {
            buttons.append(createButton(for: item))
        }
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .vertical
        stackView.spacing = -5
        
        alphabetView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: alphabetView.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: alphabetView.centerXAnchor).isActive = true
    }
    
    private func createButton(for entry: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(entry, for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(handleTapButton), for: .touchUpInside)
        return button
    }
    
    @objc private func handleTapButton(sender: UIButton) {
        guard let tag = buttons.lastIndex(of: sender) else { return }
        guard let index = sectionsName.lastIndex(of: (sender.titleLabel?.text)!) else { return }
        if tag == index {
            tableView.scrollToRow(at: IndexPath(row: 0, section: tag), at: .top, animated: true)
        }
    }
}

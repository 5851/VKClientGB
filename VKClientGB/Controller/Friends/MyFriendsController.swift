import UIKit

class MyFriendsController: UITableViewController {

    // MARK: - Variables
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
        Friend(name: "Сидоров Сидор Сидорович", iconImage: UIImage(named: "friend"), photos: [
                UIImage(named: "friend3"),
                UIImage(named: "friend3"),
                UIImage(named: "friend3"),
                UIImage(named: "friend3"),
                ]),
        Friend(name: "Семенов Семен Семенович", iconImage: UIImage(named: "friend"), photos: [
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
    
    // MARK: - Controller lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Мои друзья"
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyFriendsCell.cellId, for: indexPath) as? MyFriendsCell else {
            fatalError("Can not load group cell")
        }
        
        let friend = friends[indexPath.row]
        cell.friend = friend
        
        return cell
    }
    
    // MARK: - Navigation    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotos",
            let photosController = segue.destination as? PhotosFriendController,
            let indexPath = tableView.indexPathForSelectedRow {

            photosController.photos = friends[indexPath.row].photos
        }
    }
}

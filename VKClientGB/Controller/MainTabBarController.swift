import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Controller lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    // MARK: - Private functions
    private func setupTabBar() {
        
        viewControllers?[0].title = "Группы"
        viewControllers?[0].tabBarItem.image = UIImage(named: "groups")
        viewControllers?[0].tabBarItem.selectedImage = UIImage(named: "groupsSelected")
        viewControllers?[1].title = "Друзья"
        viewControllers?[1].tabBarItem.image = UIImage(named: "friends")
        viewControllers?[1].tabBarItem.selectedImage = UIImage(named: "friendsSelected")
        viewControllers?[2].title = "Новости"
        viewControllers?[2].tabBarItem.image = UIImage(named: "feed")
        viewControllers?[2].tabBarItem.selectedImage = UIImage(named: "feedSelected")
    }
}


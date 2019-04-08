import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        
        viewControllers?[0].title = "Группы"
        viewControllers?[0].tabBarItem.image = UIImage(named: "groups")
        viewControllers?[0].tabBarItem.selectedImage = UIImage(named: "groupsSelected")
        viewControllers?[1].title = "Друзья"
        viewControllers?[1].tabBarItem.image = UIImage(named: "friends")
        viewControllers?[1].tabBarItem.selectedImage = UIImage(named: "friendsSelected")
    }
}

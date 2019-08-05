import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Controller lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarControllers()
    }
    
    // MARK: - Private functions
    private func setupTabBarControllers() {
        
        tabBar.isTranslucent = false
        tabBar.barTintColor = .white
        viewControllers = [
            createNavController(viewController: MyGroupsController(), title: "Мои группы", imageName: "groups", imageSelectedName: "groupsSelected"),
            createNavController(viewController: MyFriendsController(), title: "Мои друзья", imageName: "friends", imageSelectedName: "friendsSelcted"),
            createNavController(viewController: FeedsController(), title: "Новости", imageName: "feed", imageSelectedName: "feedSelected")
        ]
    }
    
    private func createNavController(viewController: UIViewController, title: String, imageName: String, imageSelectedName: String) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = false
        navController.navigationBar.isTranslucent = false
        viewController.navigationItem.title = title
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = UIImage(named: imageName)
        viewController.tabBarItem.selectedImage = UIImage(named: imageSelectedName)
        return navController
    }
}


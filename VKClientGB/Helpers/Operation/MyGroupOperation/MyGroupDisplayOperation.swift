import UIKit
import RealmSwift

class MyGroupDisplayOperation: Operation {
    
    var controller: MyGroupsController
    
    init(controller: MyGroupsController) {
        self.controller = controller
    }
    
    override func main() {
        
        guard (dependencies.first(where: { $0 is MyGroupsPersistOperation }) as? MyGroupsPersistOperation) != nil
            else { return }
        
        guard let myGroups = try? RealmService.get(Group.self) else { return }

        controller.groups = myGroups
        
        controller.groupsToken = myGroups.observe({ [self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial(let results), .update(let results, _, _, _):
                self.controller.reloadTable(results: results)
            case .error(let error):
                fatalError(error.localizedDescription)
            }
        })
    }
}


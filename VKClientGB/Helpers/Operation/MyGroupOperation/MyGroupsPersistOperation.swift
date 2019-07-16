import UIKit

class MyGroupsPersistOperation: Operation {
    
    override func main() {
        guard let parseOperation = dependencies.first(where: { $0 is MyGroupsParseDataOperation }) as? MyGroupsParseDataOperation else { return }
        
        try? RealmService.save(items: parseOperation.groups)
    }
}

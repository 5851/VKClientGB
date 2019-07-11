import Foundation
import RealmSwift

class ParseData: Operation {
    
    var outputData: Results<Group> = try! RealmService.get(Group.self).sorted(byKeyPath: "name")
    
    override func main() {
        guard let getDataOperation = dependencies.first as? GetDataOperation,
            let data = getDataOperation.data else { return }
        do {
            let decoder = JSONDecoder()
            let objects = try decoder.decode(GroupsResponseWrapped.self, from: data)
            try RealmService.save(items: objects.response.items)
            outputData = try RealmService.get(Group.self)
        } catch {
            print("Ошибка")
        }
    }
}

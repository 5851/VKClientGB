import UIKit

class RealodTableController: Operation {
    
    var controller: MyGroupsController
    
    init(controller: MyGroupsController) {
        self.controller = controller
    }
    
    override func main() {
        guard let parseData = dependencies.first as? ParseData else { return }
        controller.groups = parseData.outputData
        controller.tableView.reloadData()
    }
}

import UIKit

class FeedsController: UITableViewController {

    // MARK: - Variables
    private var feedViewModel = FeedViewModel.init(cell: [])
    var cellLayoutCalculator: FeedCellLayoutCalculatorProtocol = FeedCellLayoutCalculator()
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_Ru")
        df.dateFormat = "d MMM 'в' HH:mm"
        return df
    }()
    
    // MARK: - Controller lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Новости"
        setupTableView()
    
        AlamofireService.shared.fetchNewsFeed { [weak self] feedResposne in
            guard let self = self else { return }
            
            let cells = feedResposne.items.map({ feedItem in
                self.cellViewModel(from: feedItem,
                                   profiles: feedResposne.profiles,
                                   groups: feedResposne.groups)
            })
            
            self.feedViewModel = FeedViewModel.init(cell: cells)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cell.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedsCell.cellId, for: indexPath) as? FeedsCell else {
            fatalError("Can not load feed cell")
        }
        
        let cellViewModel = feedViewModel.cell[indexPath.row]
        cell.set(viewModel: cellViewModel)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 212
    }
    
    //MARK: - private functions    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "FeedsCell", bundle: nil), forCellReuseIdentifier: FeedsCell.cellId)
        tableView.estimatedRowHeight = 500
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        view.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    }
    
    private func cellViewModel(from feedItem: NewsFeedModel, profiles: [ProfileNews], groups:[GroupNews]) -> FeedViewModel.Cell {
        
        let profile = self.profile(for: feedItem.source_id, profiles: profiles, groups: groups)
        let photoAttachment = self.photoAttachment(feedItem: feedItem)
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormatter.string(from: date)
        let postText = feedItem.text?.replacingOccurrences(of: "<br>", with: "\n")

        let sizes = cellLayoutCalculator.sizes(postText: feedItem.text, photoAttachmant: photoAttachment)
        
        return FeedViewModel.Cell.init(iconUrlString: profile.photo,
                                       name: profile.name,
                                       date: dateTitle,
                                       text: postText,
                                       likes: formattedCounter(feedItem.likes?.count),
                                       comments: formattedCounter(feedItem.comments?.count),
                                       shares: formattedCounter(feedItem.reposts?.count),
                                       views: formattedCounter(feedItem.views?.count),
                                       photoAttachment: photoAttachment,
                                       sizes: sizes)
    }
    
    private func profile(for sourceId: Int, profiles: [ProfileNews], groups: [GroupNews]) -> ProfileRepresentable {
        
        let profilesOrGroups: [ProfileRepresentable] = sourceId >= 0 ? profiles : groups
        let normalSourceId = sourceId >= 0 ? sourceId : -sourceId
        let profileRepresentable = profilesOrGroups.first { (myProfileRepresantable) -> Bool in
            myProfileRepresantable.id == normalSourceId
        }
        return profileRepresentable!
    }
    
    private func photoAttachment(feedItem: NewsFeedModel) -> FeedViewModel.FeedCellPhotoAttachment? {
        guard let photos = feedItem.attachments?.compactMap({ attachment in
            attachment.photo
        }), let firstPhoto = photos.first else {
            return nil
        }
        return FeedViewModel.FeedCellPhotoAttachment.init(photoUrlString: firstPhoto.srcBIG,
                                                          width: firstPhoto.width,
                                                          height: firstPhoto.height)
    }
    
    private func formattedCounter(_ counter: Int?) -> String? {
        guard let counter = counter, counter > 0 else { return "0" }
        var counterString = String(counter)
        
        if 4...6 ~= counterString.count {
            counterString = String(counterString.dropLast(3)) + "K"
        } else if counterString.count > 6 {
            counterString = String(counterString.dropLast(6)) + "M"
        }
        
        return counterString
    }
}

import UIKit

class FeedsController: UITableViewController {

    // MARK: - Variables
    private var feedViewModel = FeedViewModel.init(cell: [])
    var cellLayoutCalculator: FeedCellLayoutCalculatorProtocol = FeedCellLayoutCalculator()
    private let imageService = ImageService()
    var isPrefetching = true
    var nextFrom = ""
    
    private var refreshedControl: UIRefreshControl? = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .black
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()

    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_Ru")
        df.dateFormat = "d MMM 'в' HH:mm"
        return df
    }()
    
    // MARK: - Controller lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        fetchNewsFeed()
    }
    
    //MARK: - private functions
    private func setupTableView() {
        let topInset: CGFloat = 8
        tableView.contentInset.top = topInset
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.backgroundColor : UIColor.white]
        
        tableView.register(NewsFeedCodeCell.self, forCellReuseIdentifier: NewsFeedCodeCell.cellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .lightGray
        tableView.allowsSelection = false
        tableView.prefetchDataSource = self
        guard let refreshedControl = refreshedControl else { return }
        tableView.addSubview(refreshedControl)
        
        tableView.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
    }
    
    private func cellViewModel(from feedItem: NewsFeedModel, profiles: [ProfileNews], groups:[GroupNews]) -> FeedViewModel.Cell {
        
        let profile = self.profile(for: feedItem.source_id, profiles: profiles, groups: groups)
        let photoAttachments = self.photoAttachments(feedItem: feedItem)
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormatter.string(from: date)
        let postText = feedItem.text?.replacingOccurrences(of: "<br>", with: "\n")

        let sizes = cellLayoutCalculator.sizes(postText: feedItem.text, photoAttachmants: photoAttachments)
        
        return FeedViewModel.Cell.init(iconUrlString: profile.photo,
                                       name: profile.name,
                                       date: dateTitle,
                                       text: postText,
                                       likes: formattedCounter(feedItem.likes?.count),
                                       comments: formattedCounter(feedItem.comments?.count),
                                       shares: formattedCounter(feedItem.reposts?.count),
                                       views: formattedCounter(feedItem.views?.count),
                                       photoAttachements: photoAttachments,
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
    
    private func photoAttachments(feedItem: NewsFeedModel) -> [FeedViewModel.FeedCellPhotoAttachment] {
        guard let attachments = feedItem.attachments else { return [] }
        return attachments.compactMap({ (attachment) -> FeedViewModel.FeedCellPhotoAttachment? in
            guard let photo = attachment.photo else { return nil }
            return FeedViewModel.FeedCellPhotoAttachment.init(photoUrlString: photo.srcBIG, width: photo.width, height: photo.height)
        })
    }
    
    fileprivate func fetchNewsFeed() {
        
        NewsFeedRequest.fetchNewsFeed { (nextfrom, news) in
            
            print(nextfrom)
            self.nextFrom = nextfrom
            
            let cells = news.items.map({ feedItem in
                self.cellViewModel(from: feedItem,
                                   profiles: news.profiles,
                                   groups: news.groups)
            })
            self.feedViewModel = FeedViewModel.init(cell: cells)
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
            
            self.isPrefetching = false
        }
//        NewsFeedRequest.fetchNewsFeedWithRequestRouter(urlRequest: RequestRouter.getNewsFeed(parameters: ParametersVK.newsFeedParameters(startFrom: <#T##String#>))) { [weak self] (result) in
//            guard let self = self else { return }
//
//            switch result {
//            case .success(let data):
//                let cells = data.response.items.map({ feedItem in
//                    self.cellViewModel(from: feedItem,
//                                       profiles: data.response.profiles,
//                                       groups: data.response.groups)
//                })
//                self.feedViewModel = FeedViewModel.init(cell: cells)
//
//                DispatchQueue.main.async {
//                    self.activityIndicator.stopAnimating()
//                }
//
//            case .failure(let error):
//                print("Error: \(error)")
//            }
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//        isPrefetching = false
    }
    
    @objc private func  refresh() {
        fetchNewsFeed()
        refreshedControl?.endRefreshing()
    }
    
    private func formattedCounter(_ counter: Int?) -> String? {
        guard let counter = counter, counter > 0 else { return "" }
        var counterString = String(counter)
        
        if 4...6 ~= counterString.count {
            counterString = String(counterString.dropLast(3)) + "K"
        } else if counterString.count > 6 {
            counterString = String(counterString.dropLast(6)) + "M"
        }
        return counterString
    }
}

extension FeedsController {
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cell.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedCodeCell.cellId, for: indexPath) as! NewsFeedCodeCell

        let cellViewModel = feedViewModel.cell[indexPath.row]
        cell.set(viewModel: cellViewModel, by: imageService)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cell[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
}

extension FeedsController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        let maxSection = indexPaths
            .map { $0.item }
            .reduce(indexPaths[0].item, max)
        
        guard !isPrefetching, maxSection > (feedViewModel.cell.count - 5) else { return }
        isPrefetching = true
        
        print(feedViewModel.cell.count)
        print("🥶 Prefetching news ...")
        NewsFeedRequest.fetchNewsFeed { [weak self] (nextfrom, news) in
            guard let self = self else { return }
            self.nextFrom = nextfrom
            print(nextfrom)
            let cells = news.items.map({ feedItem in
                self.cellViewModel(from: feedItem,
                                   profiles: news.profiles,
                                   groups: news.groups)
            })
            
            self.feedViewModel.cell.append(contentsOf: cells)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        self.isPrefetching = false
    }
}

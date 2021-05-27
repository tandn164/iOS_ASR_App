//
//  AppTableView.swift
//

import Foundation
import UIKit
import PullToRefresh

class AppTableView: UITableView {
    fileprivate var ___loaded = false // stupid bug
    var forceReloadToAddItems = true
    var autoLoad = true
    var sectionData = 0
    var sectionLoading = 1
    var maxNumberOfSections = 2

    fileprivate var controllers: [BaseController] = []
    
    var controller: ListControllable?
    var isShowLoadMoreIndicator = false
    var activityIndicator: UIActivityIndicatorView?
    var loadingView: LoadingAnimation!
    var topRefresher : PullToRefresh?
    
    var reverseScrolling: Bool = false

    var lastContentOffset: CGPoint!
    
    var endLoading: Bool = false
    var emptyDataTitle: String = "text_01".localized {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    func initView() {
        if tableFooterView == nil {
            let footer = UIView(frame: CGRect.zero)
            footer.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
            tableFooterView = footer
        }
        self.separatorColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        self.estimatedRowHeight = 70
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cellLayoutMarginsFollowReadableWidth = false
    }
    
    override func viewDidAppear(_ data: Any? = nil) {
        super.viewDidAppear()
        for controller in controllers {
            controller.isPause = false
        }
        self.dataSource = self
        self.delegate = self

//        if !reverseScrolling && loadingView == nil {
//            let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 60)
//            loadingView = LoadingAnimation(frame: frame)
//            loadingView.autoresizingMask = [.flexibleWidth, .flexibleHeight,.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
//            self.addPullToRefreshWithAction({ [weak self] in
//                self?.onRefreshList()
//                }, withAnimator: self, withSubview: loadingView
//            )
//        }
        
        if !reverseScrolling && topRefresher == nil {
//            let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 60)
//            loadingView = LoadingAnimation(frame: frame)
//            loadingView.autoresizingMask = [.flexibleWidth, .flexibleHeight,.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
//            topRefresher = PullToRefresh(refreshView: loadingView, animator: LoadingViewAnimator(refreshView: loadingView), height: 40, position: .top)
            topRefresher = PullToRefresh(height: 40, position: .top)
            topRefresher?.setEnable(isEnabled: true)
            self.addPullToRefresh(topRefresher!) { [weak self] in
                self?.onRefreshList()
            }
        }
        
        self.register(UINib.init(nibName: String(describing: LoadingTableViewCell.self), bundle: nil), forCellReuseIdentifier: Constant.ViewId.loadingCell)
        
        if autoLoad {
            getList()
        }
    }

    override func viewDidReappear(_ data: Any? = nil) {
        super.viewDidReappear(data)

        if self.pullToRefreshView?.loading ?? false {
            endRefreshing()
        }

        for controller in controllers {
            controller.isPause = false
        }
    }

    override func viewWillDisappear() {
        super.viewWillDisappear()

        for controller in controllers {
            controller.isPause = true
        }
    }
    
    final func createLoadingCell(_ indexPath: IndexPath) -> UITableViewCell {
        let loadingCell = self.dequeueReusableCell(withIdentifier: Constant.ViewId.loadingCell, for: indexPath)
        loadingCell.selectionStyle = .none
        return loadingCell
    }
    
    @objc func onRefreshList() {
        getList()
//        hideLoadMoreIndicator()
    }
    
    override func update(_ command: Command, data: Any?) {
        switch command {
        case controller?.stopLoadingAnimationCommand:
            //titleLabel.text = chatController.conversationDto.conversation.name
            endRefreshing()
            print("stop loading...")
        case .vShowError:
            if let error = data as? NSError {
                //titleLabel.text = error.localizedDescription
                print(error.localizedDescription)
            }
            endRefreshing()
            self.hideLoadMoreIndicator()
        case .vShowNetworkError:
            endLoading = true
            endRefreshing()
            self.showItemList()
        case controller?.updateListCommand:
            endLoading = true
            self.showItemList()
        case controller?.addItemsCommand:
            self.addItems()
        default:
            break
        }
    }

    func beginRefreshing() {
        self.startPullToRefresh()
        self.startRefreshing(at: .top)
    }

    func endRefreshing() {
        self.stopPullToRefresh()
        self.endRefreshing(at: .top)
    }
    
    func showItemList() {
        self.scrollToRightPosition()
        if controller?.hasNext ?? false {
            isShowLoadMoreIndicator = true
        } else {
            isShowLoadMoreIndicator = false
        }
        self.reloadData()
    }
    
    final func addItems() {
        if forceReloadToAddItems {
            isShowLoadMoreIndicator = controller?.hasNext ?? false
            self.reloadData()
        } else {
            beginUpdates()
            addRows()
            endUpdates()
            if controller?.hasNext ?? false {
                showLoadMoreIndicator()
            } else {
                hideLoadMoreIndicator()
            }
        }
    }
    
    func addRows() {
        let start = 0
        let end = (controller?.itemCount ?? 0) - self.numberOfRows(inSection: sectionData)
        var indexPaths = [IndexPath]()
        for i in start..<end {
            indexPaths.append(IndexPath(row: i, section: sectionData))
        }
        self.insertRows(at: indexPaths, with: .none)
    }

    final func showLoadMoreIndicator() {
        if numberOfRows(inSection: sectionLoading) < 1 {
            isShowLoadMoreIndicator = true
            self.insertRows(at: [IndexPath(row: 0, section: sectionLoading)], with: .none)
        }
        
        self.activityIndicator?.startAnimating()
    }
    
    final func hideLoadMoreIndicator() {
        if numberOfRows(inSection: sectionLoading) >= 1 {
            isShowLoadMoreIndicator = false
            if ___loaded {
                self.deleteRows(at: [IndexPath(row: 0, section: sectionLoading)], with: .none)
            }
        }
        
        self.activityIndicator?.stopAnimating()
    }
    
    func getList() {
        if ReachabilityDevice.isConnectedToNetwork() {
            controller?.getList()
        } else {
            notifyObservers(.vShowNetworkError)
        }
    }
    
    func getNextList() {
        if ReachabilityDevice.isConnectedToNetwork() {
            controller?.getNextList()
        } else {
            notifyObservers(.vShowNetworkError)
        }
    }
    
    func scrollToRightPosition() {
//        self.setContentOffset(CGPoint.zero, animated: true)
    }

    deinit {
        releaseControllers()
        removePullToRefresh(at: .top)
    }
}

extension AppTableView: UITableViewDelegate, UITableViewDataSource {
    final func numberOfSections(in tableView: UITableView) -> Int {
        return maxNumberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ___loaded = true
        switch section {
        case sectionData:
            if controller?.itemCount == 0 && endLoading {
                let view = UIView(frame: frame)
                let label = UILabel()
                label.text = emptyDataTitle
                label.font = UIFont(name: "Fira Sans", size: 14)
                label.textColor = AppResources.Color.fm_emptyDataText
                label.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(label)
                backgroundView = view
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            } else {
                backgroundView = nil
            }
            return controller?.itemCount ?? 0
        case sectionLoading:
            return isShowLoadMoreIndicator ? 1 : 0
        default:
            fatalError("Invallid section.")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case sectionData:
            return UITableView.automaticDimension
        case sectionLoading:
            return 20
        default:
            fatalError("Invallid section.")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == sectionLoading {
            return self.createLoadingCell(indexPath)
        }
        fatalError("Please implement method: cellForRowAt")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let loadingCell = cell as? LoadingTableViewCell else {
            return
        }
        
        getNextList()
        self.activityIndicator = loadingCell.activityIndicator
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        notifyObservers(.vEnableUpdateToolbarsOffset)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset
        let data = [
            Constant.ViewParam.scrollView: scrollView
        ] as [String : Any]
        notifyObservers(.vStartUpdateToolbarsOffset, data: data)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if lastContentOffset == nil { return }
        
        if scrollView.contentOffset.y < 0 {
            notifyObservers(.vShowToolbars)
        } else {
//            if scrollView.contentOffset.y + scrollView.frame.height <= scrollView.contentSize.height {
                let offset = lastContentOffset.y - scrollView.contentOffset.y
                let data = [
                    Constant.ViewParam.offset: offset,
                    Constant.ViewParam.scrollView: scrollView
                ] as [String : Any]
                notifyObservers(.vUpdateToolbarsOffset, data: data)
//            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if lastContentOffset == nil { return }
        
        let offset = lastContentOffset.y - scrollView.contentOffset.y
        let data = [
            Constant.ViewParam.offset: offset,
            Constant.ViewParam.scrollView: scrollView
        ] as [String : Any]
        
        notifyObservers(.vUpdateToolbarsVisibility, data: data)
        lastContentOffset = nil
        if decelerate {
            notifyObservers(.vDisableUpdateToolbarsOffset)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension AppTableView: ControllerManager {
    func addController(_ controller: BaseController) {
        controllers.append(controller)
    }

    func releaseControllers() {
        for controller in controllers {
            Notifier.serviceNotifier.removeObserver(controller)
        }
    }
}

extension AppTableView: PullToRefreshViewDelegate {
    func pullToRefreshAnimationDidStart(_ view: PullToRefreshView) {
        loadingView?.startAnimating()
    }

    func pullToRefreshAnimationDidEnd(_ view: PullToRefreshView) {
        loadingView?.stopAnimating()
    }

    func pullToRefresh(_ view: PullToRefreshView, progressDidChange progress: CGFloat) {

    }

    func pullToRefresh(_ view: PullToRefreshView, stateDidChange state: PullToRefreshViewState) {

    }
}

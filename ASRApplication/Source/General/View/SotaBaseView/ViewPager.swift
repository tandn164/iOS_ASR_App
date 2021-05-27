//
//  ViewPager.swift
//  ViewPager
//
//  Created by Septiyan Andika on 6/26/16.
//  Copyright © 2016 sailabs. All rights reserved.
//

import UIKit

public protocol ViewPagerDataSource: class {
    func numberOfItems(viewPager: ViewPager) -> Int
    func viewAtIndex(viewPager: ViewPager, index: Int, view: UIView?) -> UIView
}

@objc public protocol ViewPagerDelegate {
    @objc optional func didSelecteItem(at index: Int)
    @objc optional func didMoveToItem(at index: Int)
    @objc optional func didScroll()
}

public class ViewPager: UIView {

    var scrollView: UIScrollView
    var currentPosition: Int = 0
    var currentView: UIView {
        return itemViews[currentPosition]!
    }

    weak var dataSource: ViewPagerDataSource? = nil {
        didSet {
            reloadData()
        }
    }

    weak var delegate: ViewPagerDelegate?

    var numberOfItems: Int = 0
    var itemViews: Dictionary<Int, UIView> = [:]

    var shouldNotifyDidScroll = false

    required public init?(coder aDecoder: NSCoder) {
        scrollView = UIScrollView()
        super.init(coder: aDecoder)
        scrollView.frame = self.frame
        setupView()
    }

    override init(frame: CGRect) {
        scrollView = UIScrollView()
        super.init(frame: frame)
        setupView()
    }

    func setupView() {
        self.addSubview(scrollView)
        setupScrollView();
    }

    public override func viewDidAppear(_ data: Any?) {
        super.viewDidAppear(data)
//        reloadData()
    }

    func setupScrollView() {
        scrollView.isPagingEnabled = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self;
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        scrollView.forceConstraintToSuperView()
    }

    func reloadData() {
        numberOfItems = dataSource?.numberOfItems(viewPager: self) ?? 0
        
        itemViews.removeAll()
        for view in self.scrollView.subviews {
            view.removeFromSuperview()
        }

        DispatchQueue.main.async {
            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width *  CGFloat(self.numberOfItems) , height: self.scrollView.frame.height)
            self.reloadViews(index: 0)
        }

    }

    func loadViewAtIndex(index: Int){
        let view: UIView = dataSource?.viewAtIndex(viewPager: self, index: index, view: itemViews[index]) ?? UIView()

        setFrameForView(view: view, index: index);


        if(itemViews[index] == nil){
            itemViews[index] = view
//            let tap = UITapGestureRecognizer(target: self, action:  #selector(self.handleTapSubView))
//            tap.numberOfTapsRequired = 1
//            itemViews[index]!.addGestureRecognizer(tap)

            scrollView.addSubview(itemViews[index]!)
        } else {
            itemViews[index] = view
        }
    }

    func handleTapSubView() {
        delegate?.didSelecteItem?(at: currentPosition)
    }


    func reloadViews(index:Int){

        for i in (index - 1)...(index + 1) {
            if(i >= 0 && i < numberOfItems){
                loadViewAtIndex(index: i);
            }
        }

        // print(scrollView.subviews.count)
    }

    func setFrameForView(view:UIView,index:Int){
        view.frame = CGRect(x: self.scrollView.frame.width * CGFloat(index), y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
    }


    override public func layoutSubviews() {
        super.layoutSubviews()
        let width = self.scrollView.frame.width
        for index in itemViews.keys {
            let frame = CGRect(x: width * CGFloat(index), y: 0, width: width, height: self.scrollView.frame.height)
            let view = itemViews[index]
            view?.frame = frame
        }
        scrollView.contentSize = CGSize(width: width *  CGFloat(self.numberOfItems) , height: self.scrollView.frame.height)
        scrollView.isPagingEnabled = true
        let frame = CGRect(x: self.scrollView.frame.width*CGFloat(currentPosition), y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height);
        scrollView.setContentOffset(frame.origin, animated: false)
    }
}

extension ViewPager:UIScrollViewDelegate{
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        currentPosition = pageNumber
        reloadViews(index: pageNumber)
        delegate?.didMoveToItem?(at: pageNumber)
        shouldNotifyDidScroll = true
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if shouldNotifyDidScroll {
            delegate?.didScroll?()
            shouldNotifyDidScroll = false
        }
    }
}

extension ViewPager {
    func animationNext() {
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ViewPager.moveToNextPage), userInfo: nil, repeats: true)
    }
    @objc func moveToNextPage() {
        if(currentPosition <= numberOfItems && currentPosition > 0) {
            scrollTo(page: currentPosition)
            currentPosition = currentPosition + 1
            if currentPosition > numberOfItems {
                currentPosition = 1
            }
        }
    }

    func scrollTo(page index: Int) {
        if(index < numberOfItems && index >= 0) {
            let zIndex = index
            let iframe = CGRect(x: self.scrollView.frame.width*CGFloat(zIndex), y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height);
            scrollView.setContentOffset(iframe.origin, animated: true)
            reloadViews(index: zIndex)
            currentPosition = index
        }
    }
    
}

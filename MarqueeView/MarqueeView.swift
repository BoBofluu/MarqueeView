//
//  MarqueeView.swift
//  MarqueeView
//
//  Created by bobofluu on 2023/2/15.
//

import UIKit
class MarqueeView: UIView {
    /// 跑馬燈主視窗
    private lazy var scrollView = UIScrollView()
    
    /// 跑馬燈頁數
    private lazy var pageControl = UIPageControl()
    
    /// 跑馬燈前面的圖片
    private lazy var imageView = UIImageView()
    
    /// 現在顯示的跑馬燈
    private lazy var currentLabel = UILabel()
    
    /// 上一個跑馬燈
    private lazy var lastLabel = UILabel()
    
    /// 下一個跑馬燈
    private lazy var nextLabel = UILabel()
    
    /// 左右滑動時間間隔
    private var animationTimeInterval: TimeInterval = 1.0
    
    /// 時間計時器
    private var timer: Timer?
    
    /// x軸滑動
    private let MARQUEE_ANIMATION_KEY: String = "position.x"

    /// 跑馬燈索引值
    private var listCount: Int = Int() {
        didSet {
            if listCount > 0 {
                pageControl.numberOfPages = listCount
            } else {
                scrollView.isScrollEnabled = false
            }
        }
    }
    
    /// 現在顯示的跑馬燈索引值
    private var indexOfCurrent: Int = Int() {
        didSet {
            pageControl.currentPage = indexOfCurrent
        }
    }

    /// 取得下一個跑馬燈資料的索引值
    private func getNextIndex(_ index: Int) -> Int {
        return index + 1 < listCount ? index + 1 : 0
    }
    
    /// 取得上一個跑馬燈資料的索引值
    private func getLastIndex(_ index: Int) -> Int {
        // self.index - 1 : 代表目前跑馬燈為第一筆
        return index - 1 == -1 ? listCount - 1 : index - 1
    }
    
    /// 跑馬燈開始跑的時候
    private var startTime = Date()
    
    /// 將跑馬燈暫停的時候
    private var stopTime = TimeInterval()
    
    /// 跑馬燈總共需要跑的秒數
    private var scheduledTimeInterval = TimeInterval()

    // MARK: - 外部使用的設定 ＳＴＡＲＴ
    
    /// 跑馬燈資料
    internal var list:[String] = [] {
        didSet {
            listCount = list.count
        }
    }
    
    /// 跑馬燈圖片
    internal var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    /// 跑馬燈樣式
    internal var font: UIFont? {
        didSet {
            currentLabel.font = font
            lastLabel.font = font
            nextLabel.font = font
        }
    }
    
    /// 跑馬燈文字顏色
    internal var textColor: UIColor? {
        didSet {
            currentLabel.textColor = textColor
            lastLabel.textColor = textColor
            nextLabel.textColor = textColor
        }
    }
    
    /// 跑馬燈間距
    internal var padding: CGFloat = 10.0
    
    /// 上下滑動時間間隔
    internal var timeInterval: TimeInterval = 2.5
    
    /// 文字移動速度
    internal var textSpeed: Double = 30.0
    
    /// 點擊事件
    internal var tapBinding: ((_ index: Int) -> Void)? = nil

    /// 跑馬燈初始設定
    internal func start() {
        initImageView()
        initScrollView()
        initMarqueeLabel()
        setMarqueeLabel()
        
        // 預設為第一筆，index = 1
        scrollView.setContentOffset(CGPoint(x: 0, y: self.frame.height), animated: false)
        
        // 隱藏
        pageControl.hidesForSinglePage = true
        pageControl.numberOfPages = listCount
        pageControl.backgroundColor = UIColor.clear
    }
    
    // MARK: - 外部使用的設定 ＥＮＤ
    
    /// 圖片設定
    private func initImageView() {
        let size = self.frame.height - 10
        
        imageView.frame = CGRect(x: padding, y: 5, width: size, height: size)
        
        self.addSubview(imageView)
    }
    
    /// 跑馬燈主視窗設定
    private func initScrollView() {
        let padding = imageView.frame.maxX + padding
        
        scrollView.frame = CGRect(x: padding, y: 0, width: self.frame.width - padding, height: self.frame.height)
        scrollView.contentSize = CGSize(width: 0, height: self.frame.height * 3)
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        
        self.addSubview(scrollView)
    }
    
    /// 跑馬燈設定
    private func initMarqueeLabel() {
        /**
         y: self.frame.height
         因為此跑馬燈為三個
         所以目前顯示的會設在第二個
         如下：
         lastLabel : y = height
         currentLabel : y = height x 2
         nextLabel : y = height x 3
         */

        let height = scrollView.frame.height
        let width = scrollView.frame.width
        
        // 上一筆
        lastLabel.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        scrollView.addSubview(lastLabel)
        
        // 顯示
        currentLabel.frame = CGRect(x: 0, y: self.frame.height, width: width, height: height)
        
        currentLabel.isUserInteractionEnabled = true
        
        scrollView.addSubview(currentLabel)
        
        // 點擊手勢
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapRecognizer(_:)))
        
        currentLabel.addGestureRecognizer(gesture)
        
        // 長按手勢
        let longGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(longTapRecognizer))
        
        // 長按手勢最小觸發時間
        longGesture.minimumPressDuration = 0.1
        
        // 長按手勢的手指數
        longGesture.numberOfTouchesRequired = 1
        
        currentLabel.addGestureRecognizer(longGesture)

        // 下一筆
        nextLabel.frame = CGRect(x: 0, y: self.frame.height * 2, width: width, height: height)
        
        scrollView.addSubview(nextLabel)
    }
    
    /// 透過索引值設定跑馬燈資料
    private func setMarqueeLabel() {
        // 總筆數的資料數 > 目前的索引 && > 下一筆的索引 防呆用
        if  listCount > indexOfCurrent && listCount > getNextIndex(indexOfCurrent) {
            currentLabel.text = list[indexOfCurrent]
            currentLabel.frame.size.width = currentLabel.intrinsicContentSize.width
            
            lastLabel.text = list[getLastIndex(indexOfCurrent)]
            lastLabel.frame.size.width = lastLabel.intrinsicContentSize.width
            
            nextLabel.text = list[getNextIndex(indexOfCurrent)]
            nextLabel.frame.size.width = nextLabel.intrinsicContentSize.width
            initAnimation()
        }
    }
    
    /// 動畫設定
    private func initAnimation() {
        initTimer()
        
        // 若資料長度大於scrollView寬度，則啟動左右滑動
        if currentLabel.frame.width > scrollView.frame.width {
            createAnimation()
            
            // 啟動計時器
            createTime(animationTimeInterval)
        } else {
            // 啟動計時器
            createTime()
        }
    }
    
    /// 啟動左右滑動動畫
    private func createAnimation() {
        let animation = CABasicAnimation(keyPath: MARQUEE_ANIMATION_KEY)
        animation.fromValue = currentLabel.layer.position.x
        animation.toValue = -(currentLabel.layer.position.x - scrollView.frame.width + padding)

        // 將跑馬燈等速所做的計算
        let col = currentLabel.frame.width - scrollView.frame.width
        
        animationTimeInterval = col / textSpeed
        if animationTimeInterval < 1 {
            animationTimeInterval = 1
        }
        
        animation.duration = animationTimeInterval
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        currentLabel.layer.add(animation, forKey: MARQUEE_ANIMATION_KEY)
    }
    
    /// 移除左右滑動動畫
    private func removeAnimation() {
        currentLabel.layer.removeAnimation(forKey: MARQUEE_ANIMATION_KEY)
    }
    
    /// 暫停左右滑動動畫
    private func pauseAnimation() {
        let layer: CALayer = currentLabel.layer
        let pauseTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pauseTime
    }
    
    /// 恢復左右滑動動畫
    private func resumeAnimation() {
        let layer: CALayer = currentLabel.layer
        let pauseTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pauseTime
        layer.beginTime = timeSincePause
    }
    
    /// 計時器所要做的指令
    @objc private func timerAction() {
        scrollView.setContentOffset(CGPoint(x: 0, y: self.frame.height*2), animated: true)
    }

    /// 產生計時器
    private func createTime(_ timerPlus: CFTimeInterval = 0) {
        startTime = Date()
        scheduledTimeInterval = timeInterval + timerPlus
        
        timer = Timer.scheduledTimer(timeInterval: scheduledTimeInterval, target: self,
                                          selector: #selector(timerAction),
                                          userInfo: nil, repeats: false)
    }
    
    /// 初始化計時器
    private func initTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    /// 點選當前跑馬燈
    @objc private func tapRecognizer(_ tap: UITapGestureRecognizer) {
        tapBinding?(indexOfCurrent)
    }
    
    /// 長按當前跑馬燈
    @objc func longTapRecognizer(recognizer: UIGestureRecognizer) {
        if recognizer.state == .ended {
            timer?.fireDate = Date.init(timeIntervalSinceNow: scheduledTimeInterval - stopTime)

            resumeAnimation()
        }else if recognizer.state == .began {
            // 第二秒的時候按 stopTime = 2
            stopTime = Date().timeIntervalSince(startTime)
            timer?.fireDate = Date.distantFuture
            
            pauseAnimation()
        }
    }
}

extension MarqueeView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        
        if offset == 0 { // 當滑動的高度為0，代表為第零筆
            removeAnimation()
            
            indexOfCurrent = getLastIndex(indexOfCurrent)
        } else if offset == scrollView.frame.height * 2 { // 當滑動的高度為原高度*2，代表為第二筆
            removeAnimation()
            
            indexOfCurrent = getNextIndex(indexOfCurrent)
        }
        
        // 因為更改過 indexOfCurrent ，所以要重新設定跑馬燈
        setMarqueeLabel()
        
        // 將更改過後的資料顯示設為第一筆
        scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.frame.height), animated: false)
        
        // 恢復動畫
        if currentLabel.frame.width > scrollView.frame.width {
            resumeAnimation()
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.scrollViewDidEndDecelerating(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pauseAnimation()
        initTimer()
    }
}

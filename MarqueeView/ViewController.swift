//
//  ViewController.swift
//  MarqueeView
//
//  Created by bobofluu on 2023/2/15.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var vMarqueeView: MarqueeView!
    
    @IBOutlet weak var lTapIndex: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vMarqueeView.layer.borderColor = UIColor.black.cgColor
        vMarqueeView.layer.borderWidth = 1.0
        
        vMarqueeView.list = ["跑馬燈一號測試人員：我的資料很長唷，資料跑完我就會停了！", "跑馬燈二號測試人員：我很短"]
        vMarqueeView.image = UIImage(named: "MarqueeImage")!
        vMarqueeView.font = UIFont.systemFont(ofSize: 20)
        vMarqueeView.textColor = .white
        vMarqueeView.textSpeed = 100.0
        vMarqueeView.tapBinding = { index in
            self.lTapIndex.text = "This index is : \(index)"
        }
        vMarqueeView.start()
    }
}


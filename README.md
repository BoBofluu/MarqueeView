# ![This is an image](MarqueeView/Assets.xcassets/MarqueeImage.imageset/MarqueeImage.png)MarqueeView

![未命名](https://user-images.githubusercontent.com/72377374/220232520-95203fa5-d76f-4705-a6de-47611b014cf9.gif)

### Tap

![未命名 5](https://user-images.githubusercontent.com/72377374/220232670-b3de2478-b99e-49c1-a7ad-c4942a91b4d3.gif)

### Drag && long tap to pause

![未命名 3](https://user-images.githubusercontent.com/72377374/220232536-b066392f-c1d3-4054-90e2-23fc6bba062c.gif)

# Setup

## Use Interface Builder
1. Drag an UIView object to ViewController Scene
2. Change the `Custom Class` to `MarqueeView`

![1676863656875](https://user-images.githubusercontent.com/72377374/220002889-193445b5-f8de-41a7-acaf-eb908e2090db.jpg)

# Usage

```swift
    @IBOutlet weak var marqueeView: MarqueeView!
    
    // Data
    marqueeView.list = ["Player 1, this is a so long text string, has a happy ending!", "Player 2, that's finish..."]
    marqueeView.image = UIImage(named: "MarqueeImage")!
    marqueeView.font = UIFont.systemFont(ofSize: 20)
    marqueeView.textColor = .white
    marqueeView.textSpeed = 40.0
    marqueeView.tapBinding = { index in
        // Do other updates for the selected marqueeView
    }
    
    // Start
    marqueeView.start()
```

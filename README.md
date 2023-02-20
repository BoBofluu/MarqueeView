# ![This is an image](MarqueeView/Assets.xcassets/MarqueeImage.imageset/MarqueeImage.png)MarqueeView


https://user-images.githubusercontent.com/72377374/220001988-ba5d0ee3-47fe-4421-8bcd-0630757ca200.mov

### Tap

https://user-images.githubusercontent.com/72377374/220003888-a02e1e02-47ba-4a19-a6ff-7de6374bb181.mov

### Drag && long tap to pause

https://user-images.githubusercontent.com/72377374/220004007-84700c05-7214-4c78-b8a5-3c3d221dfe9d.mov

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

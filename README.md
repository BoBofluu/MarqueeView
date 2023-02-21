# ![This is an image](MarqueeView/Assets.xcassets/MarqueeImage.imageset/MarqueeImage.png)MarqueeView

![first](https://user-images.githubusercontent.com/72377374/220235622-8c0dafb5-7a9f-4e92-b666-19a1c6280526.gif)

### Tap

https://user-images.githubusercontent.com/72377374/220235661-73065ad2-e794-4c4c-8667-59888fbd366b.mov

### Drag && long tap to pause

![third](https://user-images.githubusercontent.com/72377374/220235648-3ec39f9e-a84c-4986-a0b2-091456083df1.gif)

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

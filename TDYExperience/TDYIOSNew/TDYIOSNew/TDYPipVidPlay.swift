//
//  TDYPipVidPlay.swift
//  TDYIOSNew
//
//  Created by 唐道勇 on 16/10/13.
//  Copyright © 2016年 唐道勇. All rights reserved.
//

import UIKit
//引入框架
import AVKit
import AVFoundation

/*自定义的View*/
class TDYPipVidPlay: UIView {
    /*
     播放视频：AVPlayerLayer(需要一个界面，和播放引擎AVPlayer)。UIView显示想要显示的内容，并可以进行交换。其实显示的内容为Layer
     1.init AVPlayer
     2.AVPlayer play
     3.AVPlayer : KVO
     4.AVPictureInPictureController//创建画中画
     */
    //重写一个非常重要的方法
    override class var layerClass: Swift.AnyClass { get{
            return AVPlayerLayer.self
        }
    }
    //override class func layerClass()->AnyClass{
    //    return AVPlayerLayer.self
    //}
    
    var pipPlayer:AVPlayerLayer{
        return layer as! AVPlayerLayer
    }
    
    var pipPlayerPlay:AVPlayer{
        get{
            return pipPlayer.player!
        }
        set{
            pipPlayer.player = newValue
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

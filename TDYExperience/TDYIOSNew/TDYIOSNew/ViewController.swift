//
//  ViewController.swift
//  TDYIOSNew
//
//  Created by 唐道勇 on 16/10/12.
//  Copyright © 2016年 唐道勇. All rights reserved.
//
/**
 画中画：只有AVKit WebKit AVFundation支持。MPMoviePlayerViewController和MPMoviePlayerController不支持
    只有ipad才支持画中画
    //下面的两种功能不需要写代码，ipad自带的，在右侧滑出
    slide Over 盖在上面
    slide View 两个并列的应用
 */
import UIKit
import AVKit
import AVFoundation

var currentItiemStatus = "currentItem.status"
var mcontext = 0

/*
 1.创建一个界面，
 2.创建播放引擎
 3.实现画中画
 */
class ViewController: UIViewController,AVPictureInPictureControllerDelegate {//AVPictureInPictureControllerDelegate画中画的代理方法

    //懒加载
    lazy var player:AVPlayer = {
        let p = AVPlayer()//创建对象
        p.addObserver(self, forKeyPath: currentItiemStatus, options: .new, context: &mcontext)//添加观察
        return p
    }()
    @IBOutlet var pipView: TDYPipVidPlay!//拿到View
    
    var pipController:AVPictureInPictureController?//创建pip的Controller
    //实现观察的方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //实现画中画
        if keyPath == currentItiemStatus {
            let statusInt = change?[NSKeyValueChangeKey.newKey] as? NSNumber//拿到播放状态
            let status = AVPlayerItemStatus(rawValue:statusInt!.intValue)//拿到播放状态
            if status != .readyToPlay{//没有准备播放就return
                return
            }
            //初始化创建pip的Controller
            pipController = AVPictureInPictureController(playerLayer:pipView.pipPlayer)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let url = Bundle.main.url(forResource: "sp", withExtension: "mp4")//拿到文件URL
        let asset = AVAsset(url:url!)
        let item = AVPlayerItem(asset:asset)
        
        player.replaceCurrentItem(with: item)//视频添加到播放对像中
        pipView.pipPlayerPlay = player//赋值
        
        player.play()//播放
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - 画中画的API的使用
    //开始按钮
    @IBAction func pauseButton(_ sender: AnyObject) {
        print("点击了暂停");
        pipController?.stopPictureInPicture()//关闭画中画
    }
    //暂停按钮
    @IBAction func playButton(_ sender: AnyObject) {
        print("点击了开始");
        pipController?.startPictureInPicture()//启动画中画
    }


}


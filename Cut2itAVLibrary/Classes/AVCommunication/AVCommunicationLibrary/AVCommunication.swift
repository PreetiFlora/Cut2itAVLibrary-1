//
//  AVCommunication.swift
//  AVCommunication
//
//  Created by Preeti Ashish Sontakke on 20/05/19.
//  Copyright © 2019 Preeti. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class AVCommunication: UIView,UIGestureRecognizerDelegate{

        var avplayer : AVPlayer?
        var avplayerlayer:AVPlayerLayer?
       	var seekBarUIView: SeekBar!
       	var mediaPlayerUIView: UIView!
        var videoActionButtonView : VideoActionButtonView!
        var tapGesture :UITapGestureRecognizer!
        var activityIndicatorAndReplayButtonView : ActivityIndicatorAndReplayButtonView!
		var playbackLikelyToKeepUpKeyPathObserver: NSKeyValueObservation?
		var playbackBufferEmptyObserver: NSKeyValueObservation?
		var playbackBufferFullObserver: NSKeyValueObservation?

		var isPlaySegmentCalled: Bool = false
		var endTimeOfSegment: Int64!
    
    	override init( frame: CGRect){
        
        self.avplayer = AVPlayer()
        self.avplayerlayer = AVPlayerLayer()
       	self.seekBarUIView = SeekBar()
       	self.mediaPlayerUIView = UIView()
        self.videoActionButtonView =  VideoActionButtonView()
        self.activityIndicatorAndReplayButtonView  =  ActivityIndicatorAndReplayButtonView()
       
        super.init(frame: frame)
       	self.mediaPlayerUIView.layer.addSublayer(self.makeStream())
        avplayer?.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new,.initial], context: nil)
     	addTimeObserver()
		observeBuffering()
		addNotifications()

    	self.addSubview(seekBarUIView)
       	self.addSubview(mediaPlayerUIView)
        self.addSubview(videoActionButtonView)
        self.addSubview(activityIndicatorAndReplayButtonView)
      	self.bringSubviewToFront(seekBarUIView)
        self.bringSubviewToFront(videoActionButtonView)
        self.bringSubviewToFront(activityIndicatorAndReplayButtonView)
        self.sendSubviewToBack(mediaPlayerUIView)

        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
        tapGesture.numberOfTapsRequired = 1

        mediaPlayerUIView.backgroundColor = .clear
        videoActionButtonView.backgroundColor = UIColor.clear.withAlphaComponent(0.1)
        
//        rangeSeekSliderView.backgroundColor = .clear
        
        seekBarUIView.timeSlider.addTarget(self, action: #selector(changedValueForSlider), for:.touchDragInside)
        videoActionButtonView.forwardButton.addTarget(self,  action: #selector(forwardButtonAction), for:.touchUpInside )
        videoActionButtonView.playButton.addTarget(self,  action: #selector(playButtonAction), for:.touchUpInside )
        videoActionButtonView .backwardButton.addTarget(self,  action: #selector(backwardButtonAction), for:.touchUpInside )
		videoActionButtonView .playSegment.addTarget(self,  action: #selector(playSegmentAction), for:.touchUpInside )
        self.activityIndicatorAndReplayButtonView.replayButton.addTarget(self, action: #selector(replay), for: .touchUpInside)

        videoActionButtonView.isHidden = true
        activityIndicatorAndReplayButtonView.isHidden = false
        activityIndicatorAndReplayButtonView.replayButton.isHidden = true
        applyConstraintsToTimerSlider()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeStream()->AVPlayerLayer{
        let url = URL(string: "https://vcdn.cut2it.com/0E6xGzWkIswgSfhCMw/JQBlIssI0LEIoIM5Nx/hlsplaylist.m3u8")
//      let url = URL(string: "https://vcdn.cut2it.com/EWDgGcbSQG1kPk1rf5/iv8pwZx6MyH9PlQKpq/hlsplaylist.m3u8")
        avplayer = AVPlayer(url: url!)
        avplayerlayer = AVPlayerLayer(player: avplayer)
        return avplayerlayer!
    }

    func play(){
        avplayer?.play()
		videoActionButtonView.playButton.setImage(UIImage(named: "Pause.png"), for: .normal)
    }

    func pause(){
        avplayer?.pause()
		videoActionButtonView.playButton.setImage(UIImage(named: "Play.png"), for: .normal)
    }

    func seekTo(time:Int64){
        avplayer?.seek(to: CMTimeMake(value: time, timescale: 1000))
    }

	@objc func playSegmentAction() {
		let startTime: Int64 = 5000
		let endTime: Int64 = 15
		print(startTime, endTime, "here is the value")
		self.isPlaySegmentCalled = true
		self.endTimeOfSegment = endTime
		seekTo(time: startTime)
		play()
	}

    @objc func replay(){
        seekTo(time: 00)
        play()
    }

    func destroyStream(){
        self.avplayer = nil
        self.avplayerlayer = nil
    }

	func addNotifications() {
		NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avplayer?.currentItem)
	}

	@objc func playerDidFinishPlaying(note: NSNotification){
		self.activityIndicatorAndReplayButtonView.isHidden = false
		self.videoActionButtonView.isHidden = true
		self.activityIndicatorAndReplayButtonView.replayButton.isHidden =  false
	}

    func addTimeObserver() {
		print("add time observer")
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainqueue = DispatchQueue.main
        _ = self.avplayer?.addPeriodicTimeObserver(forInterval: interval, queue: mainqueue) {[weak self] time in
			guard let currentItem = self?.avplayer?.currentItem else {
				return
			}
		//we will observe the time and if currentTime >= endTime then pause() if isPlaySegmentCalled is true

			if self?.isPlaySegmentCalled == true {
				if ((self?.endTimeOfSegment)! <= Int64(currentItem.currentTime().seconds)) {
					print("something is wrong here")
					self?.isPlaySegmentCalled = false
					self?.videoActionButtonView.isVideoPlaying = false
					self?.pause()
				}
			}

			 self?.seekBarUIView.timeSlider.maximumValue = Float(currentItem.duration.seconds)
			//              print(" time slider value",self?.seekBarUIView.timeSlider.maximumValue)
			 self?.seekBarUIView.timeSlider.minimumValue = 0
			 self?.seekBarUIView.timeSlider.value = Float(currentItem.currentTime().seconds)
			 self?.seekBarUIView.currentTimeLabel.text = self?.gettimeStrings(from: currentItem.currentTime())



		}
    }

    func gettimeStrings(from time : CMTime) -> String {
		let totalSec = CMTimeGetSeconds(time)
		let hours = Int(totalSec/3600)
        let min = Int(totalSec/60) % 60
        let sec = Int(totalSec.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: "%i:%0.2i:%0.2i", arguments: [hours,min,sec])
        } else{
            return String(format: "%0.2i:%0.2i", arguments: [min,sec])
        }
    }

	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if object is AVPlayerItem {
			switch keyPath {
			case "playbackBufferEmpty":
				// Show loader
				print("empty buferr")
				self.activityIndicatorAndReplayButtonView.isHidden = false
				self.activityIndicatorAndReplayButtonView.videoActivityIndicator.startAnimating()
				self.activityIndicatorAndReplayButtonView.videoActivityIndicator.isHidden = false
				self.activityIndicatorAndReplayButtonView.replayButton.isHidden = true

			case "playbackLikelyToKeepUp":
				// Hide loader
				print("enough.... buferr")
				self.activityIndicatorAndReplayButtonView.isHidden = true
				self.activityIndicatorAndReplayButtonView.videoActivityIndicator.stopAnimating()
				self.activityIndicatorAndReplayButtonView.videoActivityIndicator.isHidden = true

			case "playbackBufferFull":
				// Hide loader
				print("full.... buferr")
				self.activityIndicatorAndReplayButtonView.isHidden = true
				self.activityIndicatorAndReplayButtonView.videoActivityIndicator.stopAnimating()
				self.activityIndicatorAndReplayButtonView.videoActivityIndicator.isHidden = true
			case "duration":
				print("duration......")
				if let duration = avplayer?.currentItem?.duration.seconds , duration > 0.0 {
					self.seekBarUIView.totalDuration.text = self.gettimeStrings(from: (self.avplayer?.currentItem?.duration)!)
				}
			default:
				print("some")
			}
		}
    }

	private func applyConstraintsToTimerSlider() {
		seekBarUIView.translatesAutoresizingMaskIntoConstraints = false
		seekBarUIView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
		seekBarUIView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
		seekBarUIView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
		seekBarUIView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		seekBarUIView.heightAnchor.constraint(equalToConstant: 40).isActive = true

		mediaPlayerUIView.translatesAutoresizingMaskIntoConstraints = false
		mediaPlayerUIView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
		mediaPlayerUIView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
		mediaPlayerUIView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
		mediaPlayerUIView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
		mediaPlayerUIView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		mediaPlayerUIView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		mediaPlayerUIView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
		mediaPlayerUIView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true

		videoActionButtonView.translatesAutoresizingMaskIntoConstraints = false
		videoActionButtonView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
		videoActionButtonView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
		videoActionButtonView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
		videoActionButtonView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
		videoActionButtonView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		videoActionButtonView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		videoActionButtonView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
		videoActionButtonView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true

		activityIndicatorAndReplayButtonView.translatesAutoresizingMaskIntoConstraints = false

		activityIndicatorAndReplayButtonView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
		activityIndicatorAndReplayButtonView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
		activityIndicatorAndReplayButtonView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
		activityIndicatorAndReplayButtonView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		activityIndicatorAndReplayButtonView.bottomAnchor.constraint(equalTo: self.seekBarUIView.topAnchor).isActive = true
		activityIndicatorAndReplayButtonView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        }

	@objc func playButtonAction() {
		if videoActionButtonView.isVideoPlaying {
			pause()
		} else{
			play()
		}
		videoActionButtonView.isVideoPlaying = !videoActionButtonView.isVideoPlaying
	}

	@objc func backwardButtonAction(){
		let currenttime = CMTimeGetSeconds((avplayer?.currentTime())!)
		var newTime = currenttime - 10.0

		if newTime <= 0{
			newTime = 0
		}
		let time = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
		avplayer?.seek(to: time)
		play()
	}
    
	@objc func forwardButtonAction(){
		guard let duration = avplayer?.currentItem?.duration
			else {return}
		let currenttime = CMTimeGetSeconds((avplayer?.currentTime())!)
		var newTime = currenttime + 10.0
		if newTime >= CMTimeGetSeconds(duration) {
			newTime = CMTimeGetSeconds(duration)
		} else {

		}
		print(currenttime, newTime, "here is the value for new time", CMTimeGetSeconds(duration))
		let time = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
		avplayer?.seek(to: time)
		play()
	}


	private func observeBuffering() {
		avplayer?.currentItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
		avplayer?.currentItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
		avplayer?.currentItem?.addObserver(self, forKeyPath: "playbackBufferFull", options: .new, context: nil)
	}

    @objc func handleTap(_ sender:UITapGestureRecognizer){
        if !videoActionButtonView.isHidden{
            videoActionButtonView.isHidden = true
        }
        else{
            videoActionButtonView.isHidden = false
        }
    }

    @objc func changedValueForSlider(_ sender: UISlider) {
        seekTo(time: Int64(sender.value*1000))
    }
    
}

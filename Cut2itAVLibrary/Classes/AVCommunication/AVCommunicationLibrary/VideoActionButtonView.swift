//
//  VideoActionButtons.swift
//  AVCommunication
//
//  Created by Preeti Ashish Sontakke on 20/05/19.
//  Copyright © 2019 Preeti. All rights reserved.
//

import UIKit

public class VideoActionButtonView: UIView {
    
    var forwardButton: UIButton!
    var backwardButton: UIButton!
    var playButton: UIButton!
	var playSegment: UIButton!
    var isVideoPlaying = false
    
   override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
    applyConstraintToforwardButton()
    applyConstraintTobackwardButton()
    applyConstraintToplayButton()
}
    private func setup(){
        forwardButton = UIButton()
        backwardButton = UIButton()
        playButton = UIButton()
		playSegment = UIButton()
        
        forwardButton.setImage(UIImage(named: "forward"), for: .normal)
        backwardButton.setImage(UIImage(named: "backward"), for: .normal)
        playButton.setImage(UIImage(named: "Play"), for: .normal)
		playSegment.setImage(UIImage(named: "Play"), for: .normal)

        self.addSubview(forwardButton)
        self.addSubview(backwardButton)
        self.addSubview(playButton)
		self.addSubview(playSegment)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        backwardButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
		playSegment.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func  applyConstraintToforwardButton(){
        forwardButton.centerYAnchor.constraint(equalTo: self.playButton.centerYAnchor).isActive = true
        forwardButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        forwardButton.widthAnchor.constraint(equalToConstant:30).isActive = true
         forwardButton.leadingAnchor.constraint(equalTo: self.playButton.trailingAnchor, constant: 50).isActive = true
    }
    
    private func   applyConstraintTobackwardButton(){
        backwardButton.centerYAnchor.constraint(equalTo: self.playButton.centerYAnchor).isActive = true
        backwardButton.heightAnchor.constraint(equalToConstant:30).isActive = true
        backwardButton.widthAnchor.constraint(equalToConstant:30).isActive = true
        backwardButton.trailingAnchor.constraint(equalTo: self.playButton.leadingAnchor, constant: -50).isActive = true
    }
    
    private func  applyConstraintToplayButton(){
        playButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }

	private func  applyConstraintToPlaySegmentButton(){
		playSegment.centerYAnchor.constraint(equalTo: self.playButton.centerYAnchor).isActive = true
		playSegment.heightAnchor.constraint(equalToConstant: 30).isActive = true
		playSegment.widthAnchor.constraint(equalToConstant:30).isActive = true
		playSegment.leadingAnchor.constraint(equalTo: self.forwardButton.trailingAnchor, constant: 10).isActive = true
	}
	
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
}

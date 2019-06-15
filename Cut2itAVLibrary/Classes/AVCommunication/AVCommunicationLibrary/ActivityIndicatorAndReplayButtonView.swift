//
//  ActivityIndicatorAndReplayButtonView.swift
//  AVCommunication
//
//  Created by Preeti Ashish Sontakke on 22/05/19.
//  Copyright © 2019 Preeti. All rights reserved.
//

import UIKit

class ActivityIndicatorAndReplayButtonView: UIView {
    
    var videoActivityIndicator: UIActivityIndicatorView!
    var replayButton: UIButton!
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        applyConstraintToReplayButton()
        applyConstraintToVideoActivityIndicator()
        
    }
    
    private func setup(){
        
       	videoActivityIndicator = UIActivityIndicatorView(style: .whiteLarge)
		self.backgroundColor = .clear
       	replayButton = UIButton()
       	replayButton.setImage(UIImage(named: "replay"), for: .normal)
        
        self.addSubview(videoActivityIndicator)
        self.addSubview(replayButton)

        self.translatesAutoresizingMaskIntoConstraints = false
        videoActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        replayButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func  applyConstraintToReplayButton(){
         replayButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
         replayButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
         replayButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
         replayButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
 
    private func  applyConstraintToVideoActivityIndicator(){
        videoActivityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        videoActivityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        videoActivityIndicator.heightAnchor.constraint(equalToConstant: 100).isActive = true
        videoActivityIndicator.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
}

//
//  SeekBar.swift
//  AVCommunication
//
//  Created by Preeti Ashish Sontakke on 20/05/19.
//  Copyright © 2019 Preeti. All rights reserved.
//

import UIKit

class SeekBar: UIView {

    var timeSlider: UISlider!
    var currentTimeLabel: UILabel!
    var totalDuration: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        
        applyConstraintToCurrentTimeLabel()
        applyConstraintToTotalDuration()
        applyConstraintToTimeSlider()
    }
    
    private func setup(){
        timeSlider = UISlider()
        currentTimeLabel = UILabel()
        totalDuration = UILabel()
        currentTimeLabel.textColor = .white
        totalDuration.textColor = .white
        
        self.addSubview(currentTimeLabel)
        self.addSubview(totalDuration)
        self.addSubview(timeSlider)
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        timeSlider.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        totalDuration.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func applyConstraintToTimeSlider() {
        timeSlider.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        timeSlider.leadingAnchor.constraint(equalTo: self.currentTimeLabel.trailingAnchor, constant: 15).isActive = true
        timeSlider.trailingAnchor.constraint(equalTo: self.totalDuration.leadingAnchor, constant: -15).isActive = true
    }
    
    private func applyConstraintToCurrentTimeLabel() {
        currentTimeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        currentTimeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        currentTimeLabel.trailingAnchor.constraint(equalTo: self.timeSlider.leadingAnchor, constant: -15).isActive = true
    }

    private func applyConstraintToTotalDuration() {
        totalDuration.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        totalDuration.heightAnchor.constraint(equalToConstant: 30).isActive = true
        totalDuration.widthAnchor.constraint(equalToConstant: 50).isActive = true
        totalDuration.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        totalDuration.leadingAnchor.constraint(equalTo: self.timeSlider.trailingAnchor, constant: 15).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
}

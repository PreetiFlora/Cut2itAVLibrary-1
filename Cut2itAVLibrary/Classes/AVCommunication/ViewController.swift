//
//  ViewController.swift
//  AVCommunication
//
//  Created by Preeti Ashish Sontakke on 20/05/19.
//  Copyright © 2019 Preeti. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var videoUIView: UIView!
    var av : AVCommunication!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        av = AVCommunication()
        
        videoUIView.addSubview(av)
      
        av.translatesAutoresizingMaskIntoConstraints = false
        
         av.leadingAnchor.constraint(equalTo: self.videoUIView.leadingAnchor).isActive = true
         av.trailingAnchor.constraint(equalTo: self.videoUIView.trailingAnchor).isActive = true
         av.bottomAnchor.constraint(equalTo: self.videoUIView.bottomAnchor).isActive = true
         av.topAnchor.constraint(equalTo: self.videoUIView.topAnchor).isActive = true
         av.heightAnchor.constraint(equalTo: self.videoUIView.heightAnchor).isActive = true
        av.play()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
     	av.avplayerlayer?.frame = av.mediaPlayerUIView.bounds
    }
    
}


//
//  ViewController.swift
//  Cut2itAVLibrary
//
//  Created by sikkabarkha@gmail.com on 06/15/2019.
//  Copyright (c) 2019 sikkabarkha@gmail.com. All rights reserved.
//

import UIKit
import Cut2itAVLibrary

class ViewController: UIViewController {

	@IBOutlet weak var videoUIView: UIView!
	let av = AVCommunication()
	override func viewDidLoad() {
        super.viewDidLoad()

		videoUIView.addSubview(av)

		av.translatesAutoresizingMaskIntoConstraints = false

		av.leadingAnchor.constraint(equalTo: self.videoUIView.leadingAnchor).isActive = true
		av.trailingAnchor.constraint(equalTo: self.videoUIView.trailingAnchor).isActive = true
		av.bottomAnchor.constraint(equalTo: self.videoUIView.bottomAnchor).isActive = true
		av.topAnchor.constraint(equalTo: self.videoUIView.topAnchor).isActive = true
		av.heightAnchor.constraint(equalTo: self.videoUIView.heightAnchor).isActive = true
		av.play()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		av.avplayerlayer?.frame = av.mediaPlayerUIView.bounds
	}

}


//
//  CustomMarkerView.swift
//  VehicleTracking
//
//  Created by Norhizami  on 02/03/2018.
//  Copyright © 2018 Media Prima Digital - Norhizami. All rights reserved.
//

import Foundation
import UIKit

class CustomMarkerView: UIView {
    var img: UIImage!
    var borderColor: UIColor!
    var plateNumber: String!
    
    init(frame: CGRect, image: UIImage, borderColor: UIColor, tag: Int, plateNumber: String) {
        super.init(frame: frame)
        self.img=image
        self.borderColor=borderColor
        self.tag = tag
        self.plateNumber = plateNumber
        setupViews()
    }
    
    func setupViews() {
        let imgView = UIImageView(image: img)
        imgView.frame=CGRect(x: 0, y: 0, width: 80, height: 80)
        imgView.layer.cornerRadius = 40
        imgView.layer.borderColor=borderColor?.cgColor
        imgView.layer.borderWidth=6
        imgView.clipsToBounds=true
        let lbl=UILabel(frame: CGRect(x: 0, y: 75, width: 80, height: 10))
        lbl.text = "▾"
        lbl.font=UIFont.systemFont(ofSize: 24)
        lbl.textColor = borderColor
        lbl.textAlignment = .center
        
        let plateLbl = UILabel(frame: CGRect(x: 0, y: 85, width: 80, height: 20))
        plateLbl.text = plateNumber
        plateLbl.font = UIFont.boldSystemFont(ofSize: 14)
        plateLbl.textColor = .white
        plateLbl.backgroundColor = borderColor
        plateLbl.textAlignment = .center
        plateLbl.layer.cornerRadius = 4
        
        self.addSubview(imgView)
        self.addSubview(lbl)
        self.addSubview(plateLbl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

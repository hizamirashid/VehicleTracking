//
//  VehiclePreviewView.swift
//  VehicleTracking
//
//  Created by Norhizami  on 06/03/2018.
//  Copyright © 2018 Media Prima Digital - Norhizami. All rights reserved.
//

import Foundation
import UIKit

class VehiclePreviewView: UIView {
    
    let containerView: UIView = {
        let v=UIView()
        v.translatesAutoresizingMaskIntoConstraints=false
        v.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        return v
    }()

    let lblTitle1: UILabel = {
        let lbl=UILabel()
        lbl.text = "SPEED"
        lbl.font=UIFont.systemFont(ofSize: 15)
        lbl.textColor = UIColor.white
        lbl.backgroundColor = UIColor.clear
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    let lblTitle2: UILabel = {
        let lbl=UILabel()
        lbl.text = "ENGINE"
        lbl.font=UIFont.systemFont(ofSize: 15)
        lbl.textColor = UIColor.white
        lbl.backgroundColor = UIColor.clear
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    let lblTitle3: UILabel = {
        let lbl=UILabel()
        lbl.text = "LAST SEEN"
        lbl.font=UIFont.systemFont(ofSize: 15)
        lbl.textColor = UIColor.white
        lbl.backgroundColor = UIColor.clear
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    let speed: UILabel = {
        let lbl=UILabel()
        lbl.text = "0 km/h"
        lbl.font=UIFont.boldSystemFont(ofSize: 15)
        lbl.textColor = UIColor.white
        lbl.backgroundColor = UIColor.clear
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    let engine: UILabel = {
        let lbl=UILabel()
        lbl.text = "OFF"
        lbl.font=UIFont.boldSystemFont(ofSize: 15)
        lbl.textColor = UIColor.white
        lbl.backgroundColor = UIColor.clear
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    let lastseen: UILabel = {
        let lbl=UILabel()
        lbl.text = ""
        lbl.font=UIFont.boldSystemFont(ofSize: 15)
        lbl.textColor = UIColor.white
        lbl.backgroundColor = UIColor.clear
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    let time: UILabel = {
        let lbl=UILabel()
        lbl.text = ""
        lbl.font=UIFont.boldSystemFont(ofSize: 15)
        lbl.textColor = UIColor.white
        lbl.backgroundColor = UIColor.clear
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()

    let roadLbl: UILabel = {
        let lbl=UILabel()
        lbl.text=""
        lbl.font=UIFont.boldSystemFont(ofSize: 15)
        lbl.textColor=UIColor.white
        lbl.backgroundColor = UIColor.clear
        lbl.textAlignment = .left
        lbl.layer.cornerRadius = 5
        lbl.clipsToBounds=true
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor=UIColor.clear
        self.clipsToBounds=true
        self.layer.masksToBounds=true
        setupViews()
    }
    
    func setData(engine: String, speed: String, date: String, time: String, roadLbl: String) {
        
//        engineLbl.text = title
//        speedLbl.text = title
//        dateLbl.text = title
//        timeLbl.text = title
//        roadLbl.text = title
        if engine != "0" {
            self.engine.text = "ON"
            self.engine.textColor = .green
        } else {
            self.engine.text = "OFF"
            self.engine.textColor = .red
        }
        
        
        self.speed.text = speed + " km/h"
        self.lastseen.text = date
        self.time.text = time
        self.roadLbl.text = "Jln Tun Hussien Onn, Kuala Lumpur"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        containerView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        
        containerView.addSubview(lblTitle1)
        lblTitle1.centerXAnchor.constraint(equalTo: centerXAnchor).isActive=true
        lblTitle1.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive=true
        lblTitle1.widthAnchor.constraint(equalToConstant: 90).isActive=true
        lblTitle1.heightAnchor.constraint(equalToConstant: 20).isActive=true
        
        containerView.addSubview(lblTitle2)
        lblTitle2.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        lblTitle2.rightAnchor.constraint(equalTo: lblTitle1.leftAnchor).isActive=true
        lblTitle2.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive=true
        lblTitle2.heightAnchor.constraint(equalToConstant: 20).isActive=true
        
        containerView.addSubview(lblTitle3)
        lblTitle3.leftAnchor.constraint(equalTo: lblTitle1.rightAnchor).isActive=true
        lblTitle3.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        lblTitle3.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive=true
        lblTitle3.heightAnchor.constraint(equalToConstant: 20).isActive=true
        
        //speed
        containerView.addSubview(speed)
        speed.centerXAnchor.constraint(equalTo: centerXAnchor).isActive=true
        speed.topAnchor.constraint(equalTo: lblTitle1.bottomAnchor, constant: 8).isActive=true
        speed.widthAnchor.constraint(equalToConstant: 90).isActive=true
        speed.heightAnchor.constraint(equalToConstant: 20).isActive=true
        
        //engine
        containerView.addSubview(engine)
        engine.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        engine.rightAnchor.constraint(equalTo: speed.leftAnchor).isActive=true
        engine.topAnchor.constraint(equalTo: lblTitle2.bottomAnchor, constant: 0).isActive=true
        engine.heightAnchor.constraint(equalToConstant: 20).isActive=true
        
        // lastseen
        containerView.addSubview(lastseen)
        lastseen.leftAnchor.constraint(equalTo: speed.rightAnchor).isActive=true
        lastseen.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        lastseen.topAnchor.constraint(equalTo: lblTitle3.bottomAnchor, constant: 0).isActive=true
        lastseen.heightAnchor.constraint(equalToConstant: 20).isActive=true
        
        // time
        containerView.addSubview(time)
        time.leftAnchor.constraint(equalTo: speed.rightAnchor).isActive=true
        time.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        time.topAnchor.constraint(equalTo: lastseen.bottomAnchor, constant: 0).isActive=true
        time.heightAnchor.constraint(equalToConstant: 20).isActive=true
        
        containerView.addSubview(roadLbl)
        roadLbl.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive=true
        roadLbl.rightAnchor.constraint(equalTo: rightAnchor, constant: 16).isActive=true
        roadLbl.topAnchor.constraint(equalTo: time.bottomAnchor, constant: 16).isActive=true
        roadLbl.heightAnchor.constraint(equalToConstant: 40).isActive=true
        
        
//        containerView.addSubview(lblTitle)
//        lblTitle.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive=true
//        lblTitle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive=true
//        lblTitle.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive=true
//        lblTitle.heightAnchor.constraint(equalToConstant: 35).isActive=true
        
//        addSubview(imgView)
//        imgView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
//        imgView.topAnchor.constraint(equalTo: lblTitle.bottomAnchor).isActive=true
//        imgView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
//        imgView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        
//        addSubview(lblPrice)
//        lblPrice.centerXAnchor.constraint(equalTo: centerXAnchor).isActive=true
//        lblPrice.centerYAnchor.constraint(equalTo: imgView.centerYAnchor).isActive=true
//        lblPrice.widthAnchor.constraint(equalToConstant: 90).isActive=true
//        lblPrice.heightAnchor.constraint(equalToConstant: 40).isActive=true
    }
}

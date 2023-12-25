//
//  AirlineTableViewCell.swift
//  Airlines
//
//  Created by Khater on 24/12/2023.
//

import UIKit

protocol AirlineCell: AnyObject {
    func showInfo(of airline: Airline)
}

class AirlineTableViewCell: UITableViewCell, AirlineCell {
    static let identifier = "AirlineTableViewCell"
    static func nib() -> UINib { UINib(nibName: "AirlineTableViewCell", bundle: nil) }

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        logoImageView.layer.cornerRadius = (logoImageView.frame.size.width - 1) / 2
        containerView.backgroundColor = .systemBackground
        containerView.layer.masksToBounds = false
        containerView.layer.cornerRadius = 8
        containerView.layer.shadowColor = UIColor.label.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOffset = .zero
    }
    
    func showInfo(of airline: Airline) {
        nameLabel.text = airline.name
        logoImageView.setImage(with: airline.logoURL)
    }
}

/*
 let shadowLayer = UIView()
 // Make background clear so shadow appears
 shadowLayer.backgroundColor = .clear
 // Set masks to bounds to false to avoid the shadow
 // from being clipped to the corner radius
 shadowLayer.layer.masksToBounds = false
 // Apply rounded corners
 shadowLayer.layer.cornerRadius = 8
 // Shadow
 // The color of the drop shadow
 shadowLayer.layer.shadowColor = UIColor.black.cgColor
 // How transparent the drop shadow is
 shadowLayer.layer.shadowOpacity = 0.1
 // How blurred the shadow is
 shadowLayer.layer.shadowRadius = 8
 // How far the shadow is offset from the UICollectionViewCell’s frame
 shadowLayer.layer.shadowOffset = .zero
 */

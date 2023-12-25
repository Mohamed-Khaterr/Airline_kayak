//
//  AirlineDetailsViewController.swift
//  Airlines
//
//  Created by Khater on 24/12/2023.
//

import UIKit

class AirlineDetailsViewController: UIViewController {
    
    private let viewModel: AirlineDetailsViewModel

    
    // MARK: Outlets
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    // MARK: Initilizer
    init(viewModel: AirlineDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "AirlineDetailsViewController", bundle: nil)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestures()
        viewModel.viewDidLoad()
    }
    
    
    // MARK: Helpers
    private func bind() {
        viewModel.favoriteStatus = { [weak self] isFavorite in
            let buttonImageName = isFavorite ? "heart.fill" : "heart"
            self?.favoriteButton.setImage(UIImage(systemName: buttonImageName), for: .normal)
        }
        
        viewModel.showDetails = { [weak self] airline in
            self?.nameLabel.text = airline.name
            self?.logoImageView.setImage(with: airline.logoURL)
            self?.phoneLabel.text = airline.phone.isEmpty ? "Phone number not found!" : airline.phone
            self?.phoneLabel.textColor = airline.phone.isEmpty ? .black : .blue
        }
        
        viewModel.error = { [weak self] errorMessage in
            guard let self = self else { return }
            Alert.show(on: self, title: "Error", message: errorMessage)
        }
    }
    
    private func addTapGestures() {
        let phoneTapGesture = UITapGestureRecognizer(target: self, action: #selector(phoneLabelPressed))
        phoneLabel.addGestureRecognizer(phoneTapGesture)
        phoneLabel.isUserInteractionEnabled = true
    }
    
    // MARK: - IBActions
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        viewModel.changeAirlineFavoriteStatus()
    }
    
    @IBAction func visitWebsiteButtonPressed(_ sender: UIButton) {
        if let url = viewModel.getAirlineWebsiteURL() {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func phoneLabelPressed() {
        if let url = viewModel.getAirlinePhoneNumberURL() {
            print(url)
            UIApplication.shared.open(url)
        }
    }
}

//
//  AirlinesViewController.swift
//  Airlines
//
//  Created by Khater on 24/12/2023.
//

import UIKit

class AirlinesViewController: UIViewController {
    
    private let viewModel: AirlinesViewModel
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    private lazy var favoriteSwitch = UISwitch()
    private let refreshControl = UIRefreshControl()

    
    
    // MARK: Initializers
    init(viewModel: AirlinesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "AirlinesView", bundle: nil)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Airlines"
        setupTableView()
        setupFavoriteSwitch()
        viewModel.getAirlines()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    
    // MARK: Helpers
    private func setupFavoriteSwitch() {
        favoriteSwitch.addTarget(self, action: #selector(toggleFavoriteSwitch), for: .valueChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteSwitch)
    }
    
    private func setupTableView() {
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tableView.register(AirlineTableViewCell.nib(), forCellReuseIdentifier: AirlineTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func bind() {
        viewModel.reload = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.error = { [weak self] errorMessage in
            guard let self = self else { return }
            Alert.show(on: self, title: "Error", message: errorMessage)
        }
        
        viewModel.isLoading = { [weak self] isLoading in
            if isLoading {
                self?.loadingIndicator.startAnimating()
            } else {
                self?.loadingIndicator.stopAnimating()
                self?.refreshControl.endRefreshing()
            }
        }
        
        viewModel.favoriteSwitchStatus = { [weak self] isOn in
            self?.favoriteSwitch.isOn = isOn
        }
    }
    
    @objc private func toggleFavoriteSwitch() {
        viewModel.startShowFavorites(favoriteSwitch.isOn)
        title = favoriteSwitch.isOn ? "Favorite Airlines" : "Airlines"
    }
    
    @objc func refresh(_ sender: AnyObject) {
        viewModel.refresh()
    }
}

// MARK: - UITableView DataSource
extension AirlinesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AirlineTableViewCell.identifier, for: indexPath) as! AirlineTableViewCell
        cell.accessoryType = .disclosureIndicator
        viewModel.config(cell, at: indexPath.row)
        return cell
    }
}

// MARK: - UITableView Delegate
extension AirlinesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let airlineDetailsViewModel = AirlineDetailsViewModel(airline: viewModel.airline(at: indexPath.row),
                                                              dbService: FavoriteAirlinesDB())
        let airlineDetailsVC = AirlineDetailsViewController(viewModel: airlineDetailsViewModel)
        navigationController?.pushViewController(airlineDetailsVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


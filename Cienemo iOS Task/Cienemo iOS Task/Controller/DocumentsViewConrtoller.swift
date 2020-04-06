//
//  DocumentsViewController.swift
//  Cienemo iOS Task
//
//  Created by Omar Bassyouni on 4/5/20.
//  Copyright © 2020 Omar Bassyouni. All rights reserved.
//

import UIKit

class DocumentsViewController: UIViewController  {
    
    // MARK: - UI Variables
    private let tableView = UITableView()
    
    // MARK: - Variables
    private let viewModel: DocumentsViewModel
    
    init(viewModel: DocumentsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Initialization
    private func setupUI() {
        overrideUserInterfaceStyle = .dark
        navigationController?.overrideUserInterfaceStyle = .dark
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Documents Images"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: String(describing: ImageTableViewCell.self))
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

// MARK: - DocumentsViewModelProtocol
extension DocumentsViewController: DocumentsViewModelProtocol {
    func addItems(at indexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            self.tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    func removeItems(at indexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            self.tableView.deleteRows(at: indexPaths, with: .automatic)
        }
    }
}

// MARK: - UITableViewDataSource
extension DocumentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ImageTableViewCell.self), for: indexPath) as? ImageTableViewCell {
            cell.dataModel = viewModel.dataSource[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension DocumentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

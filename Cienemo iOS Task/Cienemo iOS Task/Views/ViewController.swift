//
//  ViewController.swift
//  Cienemo iOS Task
//
//  Created by Omar Bassyouni on 4/5/20.
//  Copyright © 2020 Omar Bassyouni. All rights reserved.
//

import UIKit

class ViewController: UIViewController  {
    
    // MARK: - UI Variables
    private let tableView = UITableView()
    
    // MARK: - Variables
    private var dirMonitor: DirectoryMonitor!
    private var imagesUrlsDataSource = [URL]()
    private let cellIdentifier = "cellIdentifier"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        startMonitoringDocumentsDirectory()
    }
    
    // MARK: - Initialization
    private func setupUI() {
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
    
    private func startMonitoringDocumentsDirectory() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        print(documentDirectory.absoluteString)
        
        dirMonitor = DirectoryMonitor(directory: documentDirectory, matching: "public.tiff", requestedResourceKeys: [.nameKey, .pathKey])
        dirMonitor.delegate = self
        try? dirMonitor.start()
    }
}

// MARK: - DirectoryMonitorDelegate
extension ViewController: DirectoryMonitorDelegate {
    func didChange(directoryMonitor: DirectoryMonitor, added: Set<URL>, removed: Set<URL>) {
        print(added)
        print("-----------------------------------")
        print(removed)
        let indexPaths = added.enumerated().map { IndexPath(row: imagesUrlsDataSource.count + $0.offset, section: 0) }
        imagesUrlsDataSource.append(contentsOf: added)
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesUrlsDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ImageTableViewCell.self), for: indexPath) as? ImageTableViewCell {
            cell.configureCell(imagesUrlsDataSource[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

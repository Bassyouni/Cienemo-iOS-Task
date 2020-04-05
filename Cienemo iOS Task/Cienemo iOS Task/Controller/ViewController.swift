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
    private var imagesUrlsDataSource = [CellDataModel]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        startMonitoringDocumentsDirectory()
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
        handleRemovedDocuments(removed)
        handleAddedDocuments(added)
    }
    
    private func handleAddedDocuments(_ newDocuments: Set<URL>) {
        let addedModelsIndexPaths = newDocuments
            .enumerated()
            .map { IndexPath(row: imagesUrlsDataSource.count + $0.offset, section: 0) }
        
        let models = newDocuments.map { CellDataModel(documentUrl: $0) }
        
        imagesUrlsDataSource.append(contentsOf: models)
        if !addedModelsIndexPaths.isEmpty {
            DispatchQueue.main.async {
                self.tableView.insertRows(at: addedModelsIndexPaths, with: .automatic)
            }
        }
    }
    
    private func handleRemovedDocuments(_ removedDocuments: Set<URL>) {
        let removedModelsIndexPaths = imagesUrlsDataSource
            .enumerated()
            .compactMap { removedDocuments.contains($0.element.documentUrl) ? $0.offset : nil }
            .map {IndexPath(row: $0, section: 0) }
        
        removedModelsIndexPaths.forEach { imagesUrlsDataSource.remove(at: $0.row) }
        if !removedModelsIndexPaths.isEmpty {
            DispatchQueue.main.async {
                self.tableView.deleteRows(at: removedModelsIndexPaths, with: .automatic)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesUrlsDataSource.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ImageTableViewCell.self), for: indexPath) as? ImageTableViewCell {
            cell.dataModel = imagesUrlsDataSource[indexPath.row % imagesUrlsDataSource.count]
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

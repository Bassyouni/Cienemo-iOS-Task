//
//  DocumentsViewModel.swift
//  Cienemo iOS Task
//
//  Created by Omar Bassyouni on 4/6/20.
//  Copyright © 2020 Omar Bassyouni. All rights reserved.
//

import Foundation

protocol DocumentsViewModelProtocol {
    func addItems(at indexPaths: [IndexPath])
    func removeItems(at indexPaths: [IndexPath])
}

class DocumentsViewModel {
    
    // MARK: - Variables
    private var dirMonitor: DirectoryMonitor!
    var dataSource = [CellDataModel]()
    var delegate: DocumentsViewModelProtocol?
    
    // MARK: - Initializers
    init() {
        startMonitoringDocumentsDirectory()
    }
    
    // MARK: - Initialization
    private func startMonitoringDocumentsDirectory() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        
        // Go To Finder press command + G
        // put the path that will be printed and you will get the document directory
        // then you can add images in that folder
        // remove "file://" from the path printed
        print(documentDirectory.absoluteString)
        
        dirMonitor = DirectoryMonitor(directory: documentDirectory, matching: "public.tiff", requestedResourceKeys: [.nameKey, .pathKey])
        dirMonitor.delegate = self
        try? dirMonitor.start()
    }
}

extension DocumentsViewModel: DirectoryMonitorDelegate {
    func didChange(directoryMonitor: DirectoryMonitor, added: Set<URL>, removed: Set<URL>) {
        handleRemovedDocuments(removed)
        handleAddedDocuments(added)
    }
    
    private func handleAddedDocuments(_ newDocuments: Set<URL>) {
        let addedModelsIndexPaths = newDocuments
            .enumerated()
            .map { IndexPath(row: dataSource.count + $0.offset, section: 0) }

        let models = newDocuments.map { CellDataModel(documentUrl: $0) }

        dataSource.append(contentsOf: models)
        if !addedModelsIndexPaths.isEmpty {
            delegate?.addItems(at: addedModelsIndexPaths)
        }
    }

    private func handleRemovedDocuments(_ removedDocuments: Set<URL>) {
       let removedModelsIndexPaths = dataSource
           .enumerated()
           .compactMap { removedDocuments.contains($0.element.documentUrl) ? $0.offset : nil }
           .map {IndexPath(row: $0, section: 0) }

       removedModelsIndexPaths
           .sorted(by: { $1 < $0 })
           .forEach {dataSource.remove(at: $0.row) }

       if !removedModelsIndexPaths.isEmpty {
            delegate?.removeItems(at: removedModelsIndexPaths)
       }
   }
}

//
//  ViewController.swift
//  Cienemo iOS Task
//
//  Created by Omar Bassyouni on 4/5/20.
//  Copyright © 2020 Omar Bassyouni. All rights reserved.
//

import UIKit

class ViewController: UIViewController  {
    
    var dirMonitor: DirectoryMonitor!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        startMonitoringDocumentsDirectory()
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

extension ViewController: DirectoryMonitorDelegate {
    func didChange(directoryMonitor: DirectoryMonitor, added: Set<URL>, removed: Set<URL>) {
        print(added)
        print("-----------------------------------")
        print(removed)
    }
}


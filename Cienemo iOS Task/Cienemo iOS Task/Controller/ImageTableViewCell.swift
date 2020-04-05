//
//  ImageTableViewCell.swift
//  Cienemo iOS Task
//
//  Created by Omar Bassyouni on 4/5/20.
//  Copyright © 2020 Omar Bassyouni. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    // MARK: - UI Variables
    private let documentImageView = AsyncImageView()
    
    // MARK: - variables
    var dataModel: CellDataModel! {
        didSet { bindUI() }
    }
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Initialization
    private func setupUI() {
        selectionStyle = .none
        documentImageView.contentMode = .scaleAspectFit
        addSubview(documentImageView)
    }
    
    private func setupConstraints() {
        documentImageView.translatesAutoresizingMaskIntoConstraints = false
        documentImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        documentImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        documentImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        documentImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    // MARK: - Actions
    private func bindUI() {
        documentImageView.loadImageUsingUrlString(url: dataModel.documentUrl)
    }
}

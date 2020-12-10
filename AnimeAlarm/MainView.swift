//
//  MainView.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/9/20.
//

import UIKit

class MainView: UIView {
    
    lazy var collectionView: UICollectionView = {
        let conifg = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: conifg)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGroupedBackground
        
        return collectionView
    }()
    
    init() {
        super.init(frame: .zero)
        setUp()
        setUpSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setUp() {
        self.backgroundColor = .blue
    }
    
    func setUpSubViews() {
        self.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}

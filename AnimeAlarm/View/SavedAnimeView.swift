//
//  SavedAnimeView.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/11/20.
//

import UIKit

class SavedAnimeView: UIView {
    
    //MARK: Properties
    let cellId = "cellId"
    var savedAlarms: [Alarm]?
    var animeData: [MediaItem]?
    
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        //DELETE
        //cv.backgroundColor = .green
        
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    
    // MARK: Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        //Register cell for collection view
        collectionView.register(SavedAnimeViewCell.self, forCellWithReuseIdentifier: cellId)
        
        //load the alarms initially in DB
        self.savedAlarms = DBClient.shared.dumpDB()
    }
    
    func refreshAlarmsView() {
        self.savedAlarms = DBClient.shared.dumpDB()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: Collection View Delegate
extension SavedAnimeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //Returns the number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedAlarms?.count ?? 1
    }
    
    //dequeues the reusable cell that will be used by collectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SavedAnimeViewCell
        if let savedAlarms = self.savedAlarms {
            let alarm = savedAlarms[indexPath.item]
            let animeID = alarm.animeID
            //save image url instead
            
            //find image url
            if let animeData = self.animeData {
                for show in animeData {
                    if(show.id == animeID) {
                        cell.cellData = show
                        break
                    }
                }
            }
        }
        //cell.backgroundColor = .red
        return cell
    }
    
    //size for my cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 250)
    }

    //reduce spacing b/w cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}

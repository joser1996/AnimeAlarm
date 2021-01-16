//
//  SavedCellView.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/16/20.
//

import UIKit
 
class NestedCollectionViewCell: BaseCellView {
    //MARK: Properties
    let cellId = "alarmCellID"
    var savedAlarms: [Alarm]?
    var animeData: [MediaItem]?
    var airingToday: [MediaItem]?
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        return cv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        collectionView.register(SavedAlarmCellView.self, forCellWithReuseIdentifier: cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        self.savedAlarms = loadAlarms()
    }

    private func loadAlarms() -> [Alarm]? {
        guard let alarmsArr: [Alarm] = DBClient.shared.dumpDB() else {
            print("In loadAlarms():: Wasn't able to load alarms")
            return nil
        }
        return alarmsArr.sorted(by: {$0.alertDate < $1.alertDate})
    }
    
    func refreshCollectionView(showingAlarms: Bool) {
        if showingAlarms {
            self.savedAlarms = loadAlarms()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } else {
            
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: Collection View Delegate Functions
extension NestedCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedAlarms?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SavedAlarmCellView
        if let savedAlarms = self.savedAlarms {
            let alarm = savedAlarms[indexPath.item]
            let animeID = alarm.animeID
            if let cellData = AnimeClient.shared.getAnimeData(forID: animeID) {
                cell.cellData = cellData
                cell.cellAlarm = alarm
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 300) //old height 250
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

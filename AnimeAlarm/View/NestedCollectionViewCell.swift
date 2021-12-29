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
    var isShowingAlarms: Bool = true
    var dataSource: [NestedCellData]?
    
    //neseted collection view
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        return cv
    }()
    
    
    //MARK: Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        collectionView.register(NestedCellView.self, forCellWithReuseIdentifier: cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //set source to be alarms
        changeDataSourceToAlarm()
    }

    //returns array of alarm objects from DB
    private func loadAlarms() -> [Alarm]? {
        guard let alarmsArr: [Alarm] = DBClient.shared.dumpDB() else {
            print("In loadAlarms():: Wasn't able to load alarms")
            return nil
        }
        return alarmsArr //sort later by date
    }
    
    //reloads the nested collection view
    func refreshCollectionView() {
        if isShowingAlarms {
            changeDataSourceToAlarm()
        } else {
            changeDataSourceToAiringToday()
            self.dataSource = self.dataSource?.sorted(by: {$0.date! < $1.date!})
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func changeDataSourceToAlarm() {
        guard let savedAlarms = self.loadAlarms() else {return}
        var tempArray: [NestedCellData] = []
        //get image url
        for alarm in savedAlarms {
            let animeID = alarm.animeID
            let dataIndex = AnimeClient.shared.animeDataIndex?[animeID]
            var imageURL: String = ""
            if dataIndex != nil {
                let media = AnimeClient.shared.animeData?[dataIndex!]
                imageURL = media?.coverImage.large ?? ""
            }
            let cellData = NestedCellData(title: alarm.label, imageURL:imageURL, date: alarm.alarmDate, today: nil)
            tempArray.append(cellData)
        }
        self.dataSource = tempArray
    }
    
    func changeDataSourceToAiringToday() {
        guard let airingToday = AnimeClient.shared.airingToday else {return}
        var tempArray: [NestedCellData] = []
        for episode in airingToday {
            let cellData = NestedCellData(title: episode.title.romaji ?? "N/A", imageURL: episode.coverImage.large ?? "", date: nil, today: Date())
            tempArray.append(cellData)
        }
        self.dataSource = tempArray
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: Collection View Delegate Functions
extension NestedCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NestedCellView
        if let dataSource = self.dataSource {
            cell.cellData = dataSource[indexPath.item]
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

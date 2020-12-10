//
//  ViewController.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/9/20.
//

import UIKit

struct AnimeTitle: Decodable {
    let id: Int
    let title: String
}
extension AnimeTitle: Hashable {}

class ViewController: UIViewController {

    let animeReminder = AnimeScheduler()
    var animeTitle: [AnimeTitle] = []
    var dataSource: UICollectionViewDiffableDataSource<Section, AnimeTitle>?
    let mainView = MainView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set up the collection vieew to be populated
        self.setUpCollectionView()
        
        
        // Do any additional setup after loading the view.
        guard let res = animeReminder.getAnimeFor(season: "WINTER") else {
            print("Request Failed")
            return
        }
        for mediaItem in res.data.Page.media {
            let id = mediaItem.id
            var title = mediaItem.title.english
            if(title == nil) {
                title = mediaItem.title.romaji ??  String(mediaItem.id)
            }
            self.animeTitle.append(AnimeTitle(id: id, title: title!))
            
        }
        self.populate(with: self.animeTitle)
    }
    
    func setUpCollectionView() {
        //first we register our cells
        let registration = UICollectionView.CellRegistration<UICollectionViewListCell, AnimeTitle> {cell, IndexPath, title in
            var content = cell.defaultContentConfiguration()
            content.text = title.title
            cell.contentConfiguration = content
        }
        
        self.dataSource = UICollectionViewDiffableDataSource<Section, AnimeTitle>(collectionView: self.mainView.collectionView) {collectionView, indexPath, title in
            collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: title)
            
        }
        
    }
    
    func populate(with title: [AnimeTitle]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnimeTitle>()
        snapshot.appendSections([.main])
        snapshot.appendItems(title)
        dataSource?.apply(snapshot)
    }


}

extension ViewController {
    enum Section {
        case main
    }
}

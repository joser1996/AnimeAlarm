//
//  HomeController.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/11/20.
//

import UIKit

struct Config {
    let countLimit: Int
    let memoryLimit: Int
    
    static let defaultConfig = Config(countLimit: 50, memoryLimit: 1024 * 1024 * 100) // 100 MB
}

//gloabal variable
let imageCache = NSCache<AnyObject, AnyObject>()

class HomeController: UICollectionViewController {
    
    // MARK: Properties
    let cellId = "cellId"
    let cellId1 = "cellId1"
    
    let animeClient = AnimeScheduler()
    let animeInfoController = AnimeInfoController()
    //Any anime data is stored in this array, retrieved by getAnimFor() method in AnimeClient class
    var animeData: [MediaItem]?
    var airingDates: [Int: Date]?
    
    let config = Config.defaultConfig
    
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        //configuring image cache
        imageCache.countLimit = config.countLimit
        imageCache.totalCostLimit = config.memoryLimit
        
        //register the cell
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RowCellView.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(SavedCellView.self, forCellWithReuseIdentifier: cellId1)
        //turn off navbar
        //navigationController?.navigationBar.isHidden = true
        navigationItem.title = "Winter 2021"
        navigationController?.navigationBar.isTranslucent = false
        // DELETE: this
        collectionView.backgroundColor = .systemGroupedBackground
        
//        collectionView.contentInset = UIEdgeInsets(top: 250, left: 0, bottom: 0, right: 0)
//        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 250, left: 0, bottom: 0, right: 0)

        collectionView.delegate = self
        
        //Fetch the data
        animeClient.getAnimeFor(season: "WINTER", vc: self)
    }

}



//MARK: Delegate Funcitons
extension HomeController: UICollectionViewDelegateFlowLayout {
    //number of cells in my collection view
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.animeData?.count ?? 0
    }

    //dequeue cells that will be used
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(indexPath.item == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId1, for: indexPath) as! SavedCellView
            cell.animeData = self.animeData
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! RowCellView
        if let arr = animeData {
            cell.animeData = arr[indexPath.item - 1]
        }

        cell.backgroundColor = .secondarySystemGroupedBackground
        return cell
    }

    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(indexPath.item == 0){
            return CGSize(width: view.frame.width, height: 300)
        }
        return CGSize(width: view.frame.width, height: 192)
    }

    //get rid of extra spacing between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //push infoViewController
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.item == 0){
            return
        }
        if let navigator = navigationController {
            if let animeData = self.animeData {
                let animeObj = animeData[indexPath.item-1]
                //forwarding data
                self.animeInfoController.animeData = animeObj
                self.animeInfoController.airingDates = self.airingDates
                navigator.pushViewController(animeInfoController, animated: false)
            }
        }
    }
    
}






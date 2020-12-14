//
//  HomeController.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/11/20.
//

import UIKit


class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: Properties
    let cellId = "cellId"
    lazy var savedAnimView: SavedAnimeView = {
        let sa = SavedAnimeView()
        sa.translatesAutoresizingMaskIntoConstraints = false
        return sa
    }()
    let animeClient = AnimeScheduler()
    let animeInfoController = AnimeInfoController()
    //Any anime data is stored in this array, retrieved by getAnimFor() method in AnimeClient class
    var animeData: [MediaItem]?
    
    let imageCache = NSCache<AnyObject, AnyObject>()

    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register the cell
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RowCellView.self, forCellWithReuseIdentifier: cellId)
        //turn off navbar
        navigationController?.navigationBar.isHidden = true
        // DELETE: this
        collectionView.backgroundColor = .systemGroupedBackground
        
        collectionView.contentInset = UIEdgeInsets(top: 250, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 250, left: 0, bottom: 0, right: 0)

        collectionView.delegate = self
        setUpSavedAnimeView()
        
        //Fetch the data
        animeClient.getAnimeFor(season: "WINTER", vc: self)
    }
    
    
    private func setUpSavedAnimeView() {
        view.addSubview(savedAnimView)
        NSLayoutConstraint.activate([
            savedAnimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            savedAnimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            savedAnimView.topAnchor.constraint(equalTo: view.topAnchor),
            savedAnimView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

}



extension HomeController {
    //number of cells in my collection view
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.animeData?.count ?? 0
    }

    //dequeue cells that will be used
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! RowCellView
        if let arr = animeData {
            cell.animeData = arr[indexPath.item]
            
        }
        cell.backgroundColor = .secondarySystemGroupedBackground
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }

    //get rid of extra spacing between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let navigator = navigationController {
            if let animeData = self.animeData {
                let animeObj = animeData[indexPath.item]
                //forwarding data
                self.animeInfoController.animeData = animeObj
                self.animeInfoController.imageCache = self.imageCache
                navigator.pushViewController(animeInfoController, animated: false)
            }
        }
    }
    
}






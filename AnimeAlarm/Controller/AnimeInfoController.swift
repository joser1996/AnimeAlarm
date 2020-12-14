//
//  AnimeInfoController.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/12/20.
//

import UIKit
class AnimeInfoController: UIViewController {

    //MARK: Properties
    lazy var animeInfoView: AnimeInfoView = {
        let ai = AnimeInfoView()
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
    
    var imageCache: NSCache<AnyObject, AnyObject>?
    
    var animeData: MediaItem? {
        didSet {
            animeInfoView.titleView.text = animeData?.title.romaji
            if let desc = animeData?.description, let imageURL = animeData?.coverImage.extraLarge {
                animeInfoView.synopsis.text = desc
                loadImageUsing(urlString: imageURL)
            }
        }
    }
        
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        // Do any additional setup after loading the view.
        setUpAnimeInfoView()
    }
    
    private func setUpAnimeInfoView() {
        view.addSubview(animeInfoView)
        NSLayoutConstraint.activate([
            animeInfoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            animeInfoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            animeInfoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            animeInfoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func loadImageUsing(urlString: String) {
        //check to see if image is cached
        if let img = imageCache?.object(forKey: ImageKey(key: urlString)) as? UIImage {
            animeInfoView.thumbNail.image = img
            print("Using Cache")
            return
        }
        
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { data, response, error in
            print("Using Data for image")
            if let error = error {
                print(error)
                return
            }
            guard let data = data else {
                print("No Data")
                return
            }
            
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data)
                let key = ImageKey(key: urlString)
                self.imageCache?.setObject(imageToCache!, forKey: key)
                self.animeInfoView.thumbNail.image = imageToCache
                self.animeInfoView.thumbNail.contentMode = .scaleAspectFill
                self.animeInfoView.thumbNail.clipsToBounds = true
            }
        }.resume()
    }

}


class ImageKey {
    
    init(key: String) {
        self.url = key
    }
    var url: String
}

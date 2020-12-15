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
        
    var animeData: MediaItem? {
        didSet {
            animeInfoView.titleView.text = animeData?.title.romaji
            if let desc = animeData?.description, let imageURL = animeData?.coverImage.extraLarge {
                animeInfoView.synopsis.text = desc
                
                animeInfoView.thumbNail.loadImageUsing(urlString: imageURL) { image in
                    if imageURL == self.animeData?.coverImage.extraLarge {
                        self.animeInfoView.thumbNail.image = image
                    }
                }
            } else {
                animeInfoView.synopsis.text = ""
                animeInfoView.thumbNail.image = nil
            }
        }
    }
    
    var imageURLString: String?
    var airingDates: [Int: Date]?
    var alarms: [Int: Date] = [:]
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        // Do any additional setup after loading the view.
        setUpAnimeInfoView()
        configureButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        animeInfoView.thumbNail.image = nil
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
    
    private func configureButton() {
        animeInfoView.saveButton.addTarget(self, action: #selector(remindMeButtonAction), for: .touchUpInside)
    }
    
    @objc private func remindMeButtonAction() {
        print("Remind Me Was Pressed!!!!")
        guard let animeId = self.animeData?.id else {
            print("Wasn't able to get anime ID")
            return
        }
        guard let airingDates = self.airingDates else {
            print("Unable to get airing dates")
            return
        }
        let airingDate = airingDates[animeId]
        print("Setting Alarm for: \(airingDate)")
    }
    
}


//rough estimate of how much memeory image uses in bytes
extension UIImage {
    var diskSize: Int {
        get {
            guard let cgImage = cgImage else {return 0}
            return cgImage.bytesPerRow * cgImage.height
        }
    }
    
}

extension UIImageView {
    
    func loadImageUsing(urlString: String, completion: @escaping (UIImage) -> Void) {
        //check to see if image is cached
        if let img = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            print("Using Cache")
            completion(img)
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
                guard let imageToCache = UIImage(data: data) else {return}
                //caching image
                imageCache.setObject(imageToCache, forKey: urlString as AnyObject, cost: imageToCache.diskSize)
                completion(imageToCache)
//                self.animeInfoView.thumbNail.image = imageToCache
            }
        }.resume()
    }
    
}

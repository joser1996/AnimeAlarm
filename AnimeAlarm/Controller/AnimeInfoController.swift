//
//  AnimeInfoController.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/12/20.
//

import UIKit
class AnimeInfoController: UIViewController {

    //MARK: Properties
    let scrollView = UIScrollView()
    //functioning as content view
    let animeInfoView = AnimeInfoView()
        
    var animeData: MediaItem? {
        didSet {
            let title: String = animeData?.title.romaji ?? "No Title"
            let imageURL: String? = animeData?.coverImage.large
            let syn: String? = animeData?.description ?? nil
            
            //set title
            animeInfoView.titleView.text = title
            
            //set image
            if let imageUrl = imageURL {
                animeInfoView.thumbNail.loadImageUsing(urlString: imageUrl) { image in
                    self.animeInfoView.thumbNail.image = image
                }
            } else {
                //place generic image here for when not found
                self.animeInfoView.thumbNail.image = nil
            }
            
            //set synopsis
            if let synopsis = syn {
                //clean up text
                let clean = synopsis.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                animeInfoView.synopsis.text = clean
            } else {
                animeInfoView.synopsis.text = "No Snyopis Provided."
            }

        }
    }
    
    var imageURLString: String?
    var airingDates: [Int: Date]?
    var alarms: [Int: Date] = [:]
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction))
        setUpScrollView()
    }
    
    @objc private func addAction() {
        let popVC = PopupController()
        //pass necessary data
        popVC.animeData = self.animeData
        self.present(popVC, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        animeInfoView.thumbNail.image = nil
    }
    
    private func setUpScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        animeInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(animeInfoView)
        //scrollView.backgroundColor = .red
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        animeInfoView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        animeInfoView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        animeInfoView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        animeInfoView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            var sum = CGFloat(0)
            for subV in self.animeInfoView.subviews {
                sum += subV.frame.height
            }
            self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: sum + 100)
        }
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
        _ = airingDates[animeId] //let airing date
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

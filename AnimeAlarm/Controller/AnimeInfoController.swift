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
            let airingAt = animeData?.nextAiringEpisode?.airingAt
            var nextDateString: String = "Next: "
            
            if airingAt != nil {
                let nextDate = Alarm.airingDay(seconds: airingAt!)
                let formatter = DateFormatter() 
                formatter.timeStyle = .short
                formatter.dateStyle = .short
                nextDateString += formatter.string(from: nextDate)
            } else {
                nextDateString += "N/A"
            }
            
            //set date label
            animeInfoView.nextAiringDate.text = nextDateString
            
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
    
}



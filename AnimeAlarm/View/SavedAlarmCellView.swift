//
//  SavedAnimeCellView.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/12/20.
//

import UIKit

class SavedAlarmCellView: BaseCellView {
    
    //MARK: Properties
    lazy var thumbNailView: UIImageView = {
        let tn = UIImageView()
        //DELETE THIS
        //tn.backgroundColor = .blue
        tn.translatesAutoresizingMaskIntoConstraints = false
        
        //set image here for now(dummy)
        tn.image = UIImage(named: "danmachi")
        tn.contentMode = .scaleAspectFill
        tn.clipsToBounds = true
        return tn
    }()
    
    var alarmLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        label.text = dateFormatter.string(from: date)
        label.textAlignment = .center
        return label
    }()
    
    var myFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
    }()
    
    var cellAlarm: Alarm? {
        didSet {
            guard let alarm = cellAlarm else { return }
            let date = alarm.alertDate
            self.alarmLabel.text = myFormatter.string(from: date)
        }
    }
    
    var cellData: MediaItem? {
        didSet {
            let imageURL = cellData?.coverImage.large ?? ""
            if(imageURL == ""){
                thumbNailView.image = nil
                thumbNailView.backgroundColor = .gray
            } else {
                thumbNailView.loadImageUsing(urlString: imageURL) { image in
                    self.thumbNailView.image = image
                    self.thumbNailView.contentMode = .scaleAspectFill
                    self.thumbNailView.clipsToBounds = true
                }
            }
        }
    }
    
    
    override func setUpViews() {
        super.setUpViews()
        addSubview(thumbNailView)
        addSubview(alarmLabel)
        
        //MARK: Constraints
        NSLayoutConstraint.activate([
            thumbNailView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            thumbNailView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
            thumbNailView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            thumbNailView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4)
        ])
        
        NSLayoutConstraint.activate([
            alarmLabel.topAnchor.constraint(equalTo: thumbNailView.bottomAnchor, constant: 5),
            alarmLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            alarmLabel.leadingAnchor.constraint(equalTo: thumbNailView.leadingAnchor),
            alarmLabel.trailingAnchor.constraint(equalTo: thumbNailView.trailingAnchor)
        ])
    }
}

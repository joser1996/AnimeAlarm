//
//  RowCellView.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/11/20.
//

import UIKit
 
class RowCellView: BaseCellView {
    
    //MARK: Properties
    lazy var titleView: UILabel = {
        let tv = UILabel(frame: .zero)
        tv.text = "This is an Anime Title"
        tv.font = .systemFont(ofSize: 25)
        tv.numberOfLines = 1
        tv.lineBreakMode = .byTruncatingTail
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var seperatorView: UIView = {
        let sv = UIView()
        sv.backgroundColor = .black
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var thumbNail: UIImageView = {
        let tn = UIImageView()
        tn.backgroundColor = .red
        tn.translatesAutoresizingMaskIntoConstraints = false
        return tn
    }()
    
    let titleHighlight: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let truncatedSyn: UILabel = {
        let tv = UILabel()
        tv.translatesAutoresizingMaskIntoConstraints = false
        let generic = """
        This is a very generic piece of text that is meant to be used as a placeholder for the actual text. I Wonder
        how much of this stuff I'm supposed to write. Okay I'm starting to run out of things to type so I must
        resort to my ultimate move. Behold the power of copy and paste........ wait for it..... here it comes!
        Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah
        Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah
        """
        tv.text = generic
        tv.numberOfLines = 5
        return tv
    }()
    
    var animeData: MediaItem? {
        didSet {
            titleView.text = animeData?.title.romaji
            
            let syn = animeData?.description ?? "Synopsis: None provided."
            let clean = syn.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            self.truncatedSyn.text = clean
            
            let imageURL = animeData?.coverImage.large ?? ""
            if(imageURL == ""){
                thumbNail.image = nil
                thumbNail.backgroundColor = .gray
            } else {
                thumbNail.loadImageUsing(urlString: imageURL) { image in
                    self.thumbNail.image = image
                    self.thumbNail.contentMode = .scaleAspectFill
                    self.thumbNail.clipsToBounds = true
                }
            }
        }
    }
    
    //MARK: Methods
    override func setUpViews() {
        //adding titleview to my RowCellView
        addSubview(thumbNail)
        addSubview(titleView)
        addSubview(titleHighlight)
        addSubview(truncatedSyn)
        addSubview(seperatorView)
        
        //MARK: Constraints
        
        //Thumbnail
        NSLayoutConstraint.activate([
            thumbNail.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            thumbNail.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            thumbNail.widthAnchor.constraint(equalToConstant: 110),
            thumbNail.heightAnchor.constraint(equalToConstant: 160)
        ])
        
        //Title
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: thumbNail.trailingAnchor, constant: 8),
            titleView.topAnchor.constraint(equalTo: thumbNail.topAnchor),
            titleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        //TitleHighlight
        NSLayoutConstraint.activate([
            titleHighlight.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            titleHighlight.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            titleHighlight.heightAnchor.constraint(equalToConstant: 1),
            titleHighlight.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 8),
        ])
        
        //Truncated Synopsis
        NSLayoutConstraint.activate([
            truncatedSyn.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            truncatedSyn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            truncatedSyn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            truncatedSyn.heightAnchor.constraint(equalToConstant: 110)
        ])
        
        //CellSeperator
        NSLayoutConstraint.activate([
            seperatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            seperatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            seperatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            seperatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
}


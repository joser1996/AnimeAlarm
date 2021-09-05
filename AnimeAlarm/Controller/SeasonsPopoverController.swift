//
//  SeasonsPopoverController.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 9/4/21.
//

import Foundation
import UIKit


class SeasonsPopoverController: UITableViewController {
    
    var homeController: HomeController?
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.register(SeasonViewCell.self, forCellReuseIdentifier: "seasonCell")
        tableView.rowHeight = CGFloat(50)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfSeasons: Int = 4
        return numberOfSeasons
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "seasonCell", for: indexPath) as! SeasonViewCell
        cell.setUpView(season: SeasonsHelper.shared.seasons?[indexPath.item])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedSeason = SeasonsHelper.shared.seasons?[indexPath.item] {
            print("Selected Season: ", selectedSeason)
            AnimeClient.shared.clearData()
            AnimeClient.shared.getAnimeFor(season: selectedSeason, vc: homeController!, currentPage: 1)
        }
        
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

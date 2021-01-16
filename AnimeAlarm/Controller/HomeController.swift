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
    //Controls Detailed Information View
    let animeInfoController = AnimeInfoController()
    //Reference to first cell that hold nested collection view
    var refNestedCell: NestedCollectionViewCell?
    //showing saved alarms
    var showingAlarmView: Bool = true
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //configuring image cache
        imageCache.countLimit = Config.defaultConfig.countLimit
        imageCache.totalCostLimit = Config.defaultConfig.memoryLimit
        
        //register cells
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RowCellView.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(NestedCollectionViewCell.self, forCellWithReuseIdentifier: cellId1)

        navigationItem.title = "Winter 2021"
        navigationController?.navigationBar.isTranslucent = false
        //toggle nested collection view button
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(toggleAction))
        
        // DELETE: this
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.delegate = self
        
        //Fetch the data
        AnimeClient.shared.getAnimeFor(season: "WINTER", vc: self, currentPage: 1)
        AnimeClient.shared.buildAiringToday(currentDate: Date())
        
//      DBClient.shared.wipeDB()
        //This should be in app deleage to ensure you don't miss any notifications
        UNUserNotificationCenter.current().delegate = self
        self.cleanAlarmView()
    }
    
    @objc func toggleAction() {
        //switch whatever the nested view is showing
        self.showingAlarmView.toggle()
        //reload the nested collection view
        self.refNestedCell?.refreshCollectionView(showingAlarms: self.showingAlarmView)
    }
    
    func cleanAlarmView() {
        guard let savedAlarms = DBClient.shared.dumpDB() else {return}
        var pendingIDs: [Int] = []
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            for notification in notifications {
                let id = notification.identifier
                if let alarmID = Int(id)  {
                    pendingIDs.append(alarmID)
                }
            }
            
            //for any alarm not found in pending remove
            for alarm in savedAlarms {
                if let alarmID = alarm.alarmID {
                    if !pendingIDs.contains(alarmID) {
                        DBClient.shared.deleteAlarm(alarm_id: alarmID)
                    }
                }
            }
            
            self.refNestedCell?.refreshCollectionView(showingAlarms: self.showingAlarmView)
        }
    }
    
}

extension HomeController: UNUserNotificationCenterDelegate {
    
    //when the app is running in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Recieved notification while in foreground")
        //show alert
        completionHandler([.banner, .sound])

        let _ = notification.request.content

        //update interface
        let notificationID = notification.request.identifier
        guard let alarmID = Int(notificationID) else {
            print("Failed to get alarm id")
            return
            
        }
        //remove alarm
        DBClient.shared.deleteAlarm(alarm_id: alarmID)
        self.refNestedCell?.refreshCollectionView(showingAlarms: self.showingAlarmView)
    }
    
    //when the user selects a custom action
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("In custom action")
        guard let savedAlarms = DBClient.shared.dumpDB() else {return}
        var pendingIDs: [Int] = []
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            for notification in notifications {
                let id = notification.identifier
                if let alarmID = Int(id)  {
                    pendingIDs.append(alarmID)
                }
            }
            
            //for any alarm not found in pending remove
            for alarm in savedAlarms {
                if let alarmID = alarm.alarmID {
                    if !pendingIDs.contains(alarmID) {
                        DBClient.shared.deleteAlarm(alarm_id: alarmID)
                    }
                }
            }
            
            self.refNestedCell?.refreshCollectionView(showingAlarms: self.showingAlarmView)
        }
        

        switch response.actionIdentifier {
        case "DISMISS_ACTION":
            print("DismissAction")
            break
        case "SNOOZE_ACTION":
            print("Snooze action")
            break
        default:
            break
        }
    }
}

//MARK: Delegate Funcitons
extension HomeController: UICollectionViewDelegateFlowLayout {
    //number of cells in my collection view
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AnimeClient.shared.animeData?.count ?? 0
    }

    //dequeue cells that will be used
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //First cell is special (Collection View Horizontal Scroll)
        if(indexPath.item == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId1, for: indexPath) as! NestedCollectionViewCell
            cell.animeData = AnimeClient.shared.animeData
            cell.airingToday = AnimeClient.shared.airingToday
            
            self.refNestedCell = cell
            return cell
        }
        
        //Regular row cell
        let rowCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! RowCellView
        if let animeData = AnimeClient.shared.animeData {
            rowCell.data = animeData[indexPath.item - 1]
        }
        rowCell.backgroundColor = .secondarySystemGroupedBackground
        return rowCell
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
        if(indexPath.item == 0){ return }
        
        if let navigator = navigationController {
            if let animeData = AnimeClient.shared.animeData {
                self.animeInfoController.animeData = animeData[indexPath.item - 1]
                navigator.pushViewController(animeInfoController, animated: false)
            }
        }
    }
    
    //currently refreshed nested collection view
    override func viewWillAppear(_ animated: Bool) {
        self.cleanAlarmView()
    }
    
}






//
//  DBClient.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/29/20.
//

import Foundation
import GRDB

class DBClient {
    //MARK: Properties
    let path: String
    let tableName: String = "anime_alarms"
    var connection: DatabaseQueue?
    static let shared = DBClient()
    
   
    //MARK: Methods
    private init() {
        self.path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        self.connectToDB()
    }
        
    private func createTable(dbQueue: DatabaseQueue) {
        do {
            try dbQueue.write { db in
                try db.execute(sql: """
                CREATE TABLE \(tableName) (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                anime_id INTEGER NOT NULL,
                anime_title TEXT NOT NULL,
                isActive INTEGER NOT NULL,
                isAM INTEGER NOT NULL,
                day INTEGER NOT NULL,
                hour INTEGER NOT NULL,
                min INTEGER NOT NULL
                )
                """)
            }
        } catch {
            print("Faild to create Table")
            print("Error: \(error)")
        }
    }
    
    
    private func connectToDB() {
        do{
            let dbQueue = try DatabaseQueue( path: "\(path)/alarms_db.sqlite")
            
            //check to see if table exist
            let isCreated =  try dbQueue.read {db in
                try db.tableExists(tableName)
            }
            //create table if not
            if(!isCreated) {
                createTable(dbQueue: dbQueue)
            }
            
            self.connection = dbQueue
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
 
    
    //write to db
    func writeAlarm(alarm: Alarm) {
        let animeID = alarm.animeID
        let animeTitle = alarm.label
        let alarmDate = alarm.alarmDate
        
        guard let doesExist = doesAlarmExist(animeID: animeID) else {
            print("doesAlarmExist failed")
            return
        }
        if doesExist {
            print("Alarm already exists. Not Writing again for now")
            return
        }
        
        //TODO: Sort alarms
        //TODO: Switching b/w alarms and airing today
        
        guard let dbQueue = self.connection else {return}
        do {
            try dbQueue.write { db in
                try db.execute(
                    sql: "INSERT INTO \(tableName) (anime_id, anime_title, isActive, isAM, day, hour, min) VALUES(?, ?, ?, ?, ?, ?, ?)",
                    arguments: [animeID, animeTitle, alarm.active, alarmDate.am, alarmDate.dayWeek.rawValue, alarmDate.hour, alarmDate.min]
                )
                let rowId = db.lastInsertedRowID
                alarm.alarmID = Int(exactly: rowId) ?? -1
            }
        } catch {
            print("Failed to write alarm")
            print("Error: \(error.localizedDescription)")
        }
        
    }
    
    func doesAlarmExist(animeID: Int) -> Bool? {
        guard let dbQueue = self.connection else {return nil}
        var retVal = false
        do {
            try dbQueue.read { db in
                if let _ = try Row.fetchOne(db, sql: "SELECT * From alarms WHERE anime_id = ?", arguments: [animeID] ) {
                    print("It already exists")
                    retVal = true
                } else {
                    print("Doesn't exist")
                    retVal = false
                }
            }
        } catch {
            print("Failed in doesAlarmExist")
            print("Error: \(error.localizedDescription)")
        }
        return retVal
    }
    
    func buildAlarms(rows: [Row]) -> [Alarm] {
        var alarms: [Alarm] = []
        for row in rows {
            let alarmID: Int = row["id"]
            let animeID: Int = row["anime_id"]
            let animeTitle: String = row["anime_title"]
            let isActive: Bool = row["isActive"]
            let isAM: Bool = row["isAM"]
            let day: Int = row["day"]
            let hour: Int = row["hour"]
            let min: Int = row["min"]
            
            //Create alarmDate: AlarmDate
            let alarmDate: AlarmDate = AlarmDate(dayWeek: Day(rawValue: day)!, hour: hour, min: min, am: isAM)
            let alarm = Alarm(on: alarmDate, for: animeTitle, with: animeID, isActive: isActive)
            alarm.alarmID = alarmID
            alarms.append(alarm)
        }
        return alarms
    }
    
    //check contents of DB
    func dumpDB() -> [Alarm]? {
        guard let dbQueue = self.connection else {return nil}
        var ret: [Alarm]? = nil
        do {
            try dbQueue.read { db in
                let rows = try Row.fetchAll(db, sql: "SELECT * FROM \(tableName)")
                let alarms = buildAlarms(rows: rows)
                ret = alarms
            }
        } catch {
            print("Failed to dumb db")
            print("Error: \(error.localizedDescription)")
        }
        return ret
    }
    
    //delete alarm
    func deleteAlarm(alarm_id: Int) {
        guard let dbQueue = self.connection else {return}
        do {
            try dbQueue.write { db in
                try db.execute(
                    sql: "DELETE FROM alarms WHERE id = :id",
                    arguments: ["id": alarm_id]
                )
            }
        } catch {
            print("Unable to delete alarm with id: \(alarm_id)")
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func wipeDB() {
        guard let dbQueue = self.connection else {return}
        do {
            try dbQueue.write { db in
                try db.execute(
                    sql: "DELETE FROM alarms"
                )
            }
        } catch {
            print("Unable to delete everything")
            print("Error: \(error.localizedDescription)")
        }
    }
    
}

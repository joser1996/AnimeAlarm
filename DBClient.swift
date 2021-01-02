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
    var connection: DatabaseQueue?
    static let shared = DBClient()
    
   
    //MARK: Methods
    private init() {
        self.path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        self.connectToDB()
    }
    
    private func createTable(dbQueue: DatabaseQueue) {
        //create table if necessary
        do {
            try dbQueue.write { db in
                try db.execute(sql: """
                    CREATE TABLE alarms (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    anime_id INTEGER NOT NULL,
                    anime_title TEXT NOT NULL,
                    alarm_date_time TEXT NOT NULL,
                    airing_date_time TEXT NOT NULL,
                    isActive INTEGER NOT NULL
                    )
                    """)
            }
        } catch {
            print("Failed to create Table")
            print("Error: \(error.localizedDescription)")
        }
    }
    
    private func connectToDB() {
        do{
            let dbQueue = try DatabaseQueue( path: "\(path)/alarms_db.sqlite")
            
            //check to see if table exist
            let isCreated =  try dbQueue.read {db in
                try db.tableExists("alarms")
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
    func writeAlarm(alarm: Alarm, airingDate: Date) {
        let animeID = alarm.animeID
        let animeTitle = alarm.label
        let alarmDate = alarm.alertDate
        
        guard let dbQueue = self.connection else {return}
        do {
            try dbQueue.write { db in
                try db.execute(
                    sql: "INSERT INTO alarms (anime_id, anime_title, alarm_date_time, airing_date_time, isActive) VALUES(?, ?, ?, ?, ?)",
                    arguments: [animeID, animeTitle, alarmDate, airingDate, alarm.active]
                )
                let rowId = db.lastInsertedRowID
                alarm.alarmID = Int(exactly: rowId) ?? -1
            }
        } catch {
            print("Failed to write alarm")
            print("Error: \(error.localizedDescription)")
        }
        
    }
    
    func buildAlarms(rows: [Row]) -> [Alarm] {
        var alarms: [Alarm] = []
        for row in rows {
            let alarmID: Int = row["id"]
            let animeID: Int = row["anime_id"]
            let animeTitle: String = row["anime_title"]
            let alarmDate: Date = row["alarm_date_time"]
            let airingDate: Date = row["airing_date_time"]
            let isActive: Bool = row["isActive"]
            
            let alarm = Alarm(on: alarmDate, for: animeTitle, with: animeID, isActive: isActive)
            alarm.alarmID = alarmID
            alarm.airingDate = airingDate
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
                let rows = try Row.fetchAll(db, sql: "SELECT * FROM alarms")
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
    
}

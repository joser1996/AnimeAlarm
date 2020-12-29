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
                    alarm_date_time TEXT NOT NULL
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
            let dbQueue = try DatabaseQueue( path: "\(path)/db.sqlite")
            
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
    func writeAlarm(alarm: Alarm) {
        let animeID = alarm.animeID
        let animeTitle = alarm.label
        let alarmDate = alarm.alertDate
        
        guard let dbQueue = self.connection else {return}
        do {
            try dbQueue.write { db in
                try db.execute(
                    sql: "INSERT INTO alarms (anime_id, anime_title, alarm_date_time) VALUES(?, ?, ?)",
                    arguments: [animeID, animeTitle, alarmDate]
                )
            }
        } catch {
            print("Failed to write alarm")
            print("Error: \(error.localizedDescription)")
        }
        
    }
    
    //check contents of DB
    func dumpDB() {
        guard let dbQueue = self.connection else {return}
        
        do {
            try dbQueue.read { db in
                let rows = try Row.fetchAll(db, sql: "SELECT * FROM alarms")
                for row in rows {
                    print("\(row)")
                }
            }
        } catch {
            print("Failed to dumb db")
            print("Error: \(error.localizedDescription)")
        }
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

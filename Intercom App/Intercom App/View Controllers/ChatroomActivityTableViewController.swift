//
//  ChatroomActivityTableViewController.swift
//  Intercom App
//
//  Created by Sergey Osipyan on 4/10/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

struct Activity: Codable {
    let id: Int
    let activity, createdAt: String?
    let userId: Int
    let displayName: String
    let avatar: String?
}

extension Date {
    static func dateFromCustomString(customString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.date(from: customString) ?? Date()
    }
    
    func reduceToMonthDayYear() -> Date {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let year = calendar.component(.year, from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.date(from: "\(month)/\(day)/\(year)") ?? Date()
    }
}

class ChatroomActivityTableViewController: UITableViewController {
    
    var group: Groups?
    var callStatus: Bool?
    var activityLogs = [[Activity]]()
    var allActivities: [Activity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        TeamImporter.shared.cavc = self
        GroupController.shared.fetchGroupActiity(gropeId: group!.groupID) { (allActivities) in
            self.allActivities = allActivities
            self.attemptToAssembleGroupedMessages()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    fileprivate func attemptToAssembleGroupedMessages() {
        print("Attempt to group our messages together based on Date property")
        
        let groupedMessages = Dictionary(grouping: allActivities) { (element) -> Date in
            let date = Date.dateFromCustomString(customString: element.createdAt!)
            return date.reduceToMonthDayYear()
        }
        
        // provide a sorting for your keys somehow
        let sortedKeys = groupedMessages.keys.sorted()
        sortedKeys.forEach { (key) in
            let values = groupedMessages[key]
            activityLogs.append(values ?? [])
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return activityLogs[section].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return activityLogs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
        let activityLog = activityLogs[indexPath.section][indexPath.row]
        guard let activityString = activityLog.activity else { return cell }
        
        cell.textLabel?.text = activityLog.displayName + ": " + activityString
        cell.detailTextLabel?.text = "\(dateFormater(date: activityLog.createdAt!))"
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let firstActivity = activityLogs[section].first {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 65))
            let label = UILabel(frame: CGRect(x: 20, y: 25, width: tableView.frame.size.width, height: 65))
            label.font = UIFont.systemFont(ofSize: 14)
            let dateString = stringFormaterToString(date: firstActivity.createdAt!)
            label.text = "ACTIVITY: \(dateString)"
            label.textColor = UIColor.gray
            view.backgroundColor = UIColor.groupTableViewBackground
            view.addSubview(label)
            return view
        }
        return nil
    }
    
    func stringFormaterToString(date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: date) else {
            fatalError()
        }
        dateFormatter.dateFormat = "MMM d, yyyy" //Your New Date format as per requirement change it own
        let newDate = dateFormatter.string(from: date) //pass Date here
        // print(newDate) //New formatted Date string
        return newDate
    }
    
    func dateFormater(date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: date) else {
            fatalError()
        }
        dateFormatter.dateFormat = "MMM d, yyyy' 'HH:mm" //Your New Date format as per requirement change it own
        let newDate = dateFormatter.string(from: date) //pass Date here
        // print(newDate) //New formatted Date string
        return newDate
    }
}

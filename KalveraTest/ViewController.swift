//
//  ViewController.swift
//  KalveraTest
//
//  Created by Антон Рыскалев on 10.02.16.
//  Copyright © 2016 Антон Рыскалев. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ids = [Int]()
    var titles = [String]()
    var content = [String]()
    var classType = [String]()
    var categoryId = [Int]()
    var postedTime = [Int]()
    var commentCount = [Int]()
    var main = [Bool]()
    var link = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    enum FilterOptions {
        static let filterActivated = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let filter = NSUserDefaults.standardUserDefaults()
        filter.setValue("TimeUp", forKey: FilterOptions.filterActivated)
        refresh()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 150
        self.tableView.reloadData()
    }
    
    //Обновление данных в таблице
    func refresh() {
                self.ids.removeAll()
                self.titles.removeAll()
                self.content.removeAll()
                self.classType.removeAll()
                self.categoryId.removeAll()
                self.postedTime.removeAll()
                self.commentCount.removeAll()
                self.main.removeAll()
                self.link.removeAll()
        jsonParse()
        self.tableView.reloadData()
    }

    //Загрузка и сериализация JSON
    func jsonParse(){
        let url = NSURL(string: "http://localhost:3000/5839.json")
        let data = NSData(contentsOfURL: url!)
        
        do {
            let dict1:NSMutableDictionary = try NSJSONSerialization.JSONObjectWithData(data!,
                options:NSJSONReadingOptions.MutableContainers) as! NSMutableDictionary
            self.parseDataJson(dict1)
        } catch let parseError {
            print(parseError)
        }
}
    //Инициализация массивов сортированными данными c JSON файла
    func parseDataJson(jsonDictionary:NSDictionary) {
        let news = jsonDictionary["news"]
        var sortedResults:NSArray = ["",""]
        let filter = NSUserDefaults.standardUserDefaults()
        
        //Сортировка
        if (filter.stringForKey(FilterOptions.filterActivated) == "TimeDown") {
            let descriptor: NSSortDescriptor = NSSortDescriptor(key: "posted_time", ascending: true)
            sortedResults = news!.sortedArrayUsingDescriptors([descriptor])
        }  else if (filter.stringForKey(FilterOptions.filterActivated) == "TimeUp"){
            sortedResults = news as! NSArray
        }
        
        //Инициализация массивов
        if let news = sortedResults as? [[String: AnyObject]] {
            for new in news {
                if ((new["category_id"] as? Int) == 208 ) { //Загружает данные толко с category_id = 208!
                self.ids.append((new["id"] as? Int)! )
                self.titles.append((new["title"] as? String)! )
                self.content.append((new["content"] as? String)! )
                self.classType.append((new["class"] as? String)! )
                self.categoryId.append((new["category_id"] as? Int)! )
                self.postedTime.append((new["posted_time"] as? Int)! )
                self.commentCount.append((new["comment_count"] as? Int)! )
                self.main.append((new["main"] as? Bool)! )
                self.link.append((new["link"] as? String)! )
                }
            }
    
        }
    }
    
    //Преобразование формата времени с формата UNIX TIMESTAMP
    func timeConversion(timeUnix:Int) -> (String) {
        let currentDate = NSDate(timeIntervalSince1970: Double(timeUnix))
        let dateFormat = NSDateFormatter()
        
        dateFormat.dateFormat = "hh:mm"
        dateFormat.locale = NSLocale(localeIdentifier: "ru-RU")
        
        return dateFormat.stringFromDate(currentDate)
    }
    
    //Преобразование текста с аттрибутами
    func titlePerform(titleString: String , commentCountString: String) ->(NSMutableAttributedString) {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "comments_badge")
        let attachmentString = NSAttributedString(attachment: attachment)
        let titlePart1 = NSMutableAttributedString(string: titleString + " ")
        let titlePart2 = NSMutableAttributedString(string: commentCountString)
        
        titlePart1.appendAttributedString(attachmentString)
        titlePart1.appendAttributedString(titlePart2)
        
        return titlePart1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.content.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ResultsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! ResultsTableViewCell
        
        cell.postedTimeLabel?.text = timeConversion(self.postedTime[indexPath.row])
        if (self.categoryId[indexPath.row] == 208) {cell.categoryLabel?.text = "Футбол"}
        if (self.main[indexPath.row]) {cell.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 16.0)}
        
        cell.titleLabel.attributedText = titlePerform(self.titles[indexPath.row], commentCountString: String(self.commentCount[indexPath.row]))
        cell.titleLabel.adjustsFontSizeToFitWidth = true
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //TODO
}
    
    //Функция создания UIAlertView при нажатии на кнопку сортировки
    @IBAction func filterButtonPressed(sender: AnyObject) {
        let createAccountErrorAlert: UIAlertView = UIAlertView()
        
        createAccountErrorAlert.delegate = self
        createAccountErrorAlert.title = "Сортировка ленты"
        createAccountErrorAlert.addButtonWithTitle("Дата по убыванию")
        createAccountErrorAlert.addButtonWithTitle("Дата по возрастанию")
        createAccountErrorAlert.show()
    }
    
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        let filter = NSUserDefaults.standardUserDefaults()
        
        switch buttonIndex{
        //Дата по убыванию
        case 0:
            filter.setValue("TimeDown", forKey: FilterOptions.filterActivated)
            refresh()
            break;
        //Дата по возрастанию
        case 1:
            filter.setValue("TimeUp", forKey: FilterOptions.filterActivated)
            refresh()
            break;
        default:
            NSLog("Default");
            break;
            
        }
    }
    
}

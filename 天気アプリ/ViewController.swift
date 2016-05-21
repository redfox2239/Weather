//
//  ViewController.swift
//  天気アプリ
//
//  Created by HARADA REO on 2016/02/21.
//  Copyright © 2016年 reo harada. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    override func awakeFromNib() {
    }
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var weatherTableView: UITableView!
    var weatherData: [NSDictionary] = []
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "天気を更新する")
        self.refreshControl.addTarget(self, action: "reloadWeatherData", forControlEvents: UIControlEvents.ValueChanged)
        self.weatherTableView.addSubview(self.refreshControl)
        
        self.weatherTableView.backgroundColor = UIColor.clearColor()//blackColor().colorWithAlphaComponent(0.0)
        
        let url = NSURL(string: "https://mb.api.cloud.nifty.com/2013-09-01/applications/wa2ifiGKGN3eQzfE/publicFiles/weather.json")
        let data = NSData(contentsOfURL: url!)
        do {
            let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? [NSDictionary]
            jsonData?.enumerate().forEach({ (index,val) -> () in
                self.weatherData.append(val)
            })
        }
        catch {
            print("エラー")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! WeatherCell
        cell.cityLabel.text = self.weatherData[indexPath.row]["cityName"] as? String
        cell.minTempLabel.text = self.weatherData[indexPath.row]["minTemp"] as? String
        cell.maxTempLabel.text = self.weatherData[indexPath.row]["maxTemp"] as? String
        cell.weatherLabel.text = self.weatherData[indexPath.row]["weather"] as? String
        
        cell.backgroundColor = UIColor.clearColor()
        return cell
        
    }
    
    func reloadWeatherData() {
        self.weatherData = []
        let url = NSURL(string: "https://mb.api.cloud.nifty.com/2013-09-01/applications/wa2ifiGKGN3eQzfE/publicFiles/weather.json")
        let data = NSData(contentsOfURL: url!)
        do {
            let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? [NSDictionary]
            jsonData?.enumerate().forEach({ (index,val) -> () in
                self.weatherData.append(val)
            })
        }
        catch {
            print("エラー")
        }
        self.refreshControl.endRefreshing()
        self.weatherTableView.reloadData()
    }
}


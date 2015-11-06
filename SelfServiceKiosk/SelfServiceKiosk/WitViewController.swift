//
//  WitViewController.swift
//  SelfServiceKiosk
//
//
//  Copyright © 2015 Clover. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Wit


class WitViewController: UIViewController, WitDelegate, UITableViewDataSource, UITableViewDelegate {
  var statusView: UILabel?
  var intentView: UILabel?
  var entitiesView: UITextView?
  var witButton: WITMicButton?
    var items: [Item] = []
    var menu: [Item] = []

    @IBOutlet weak var tableView: UITableView!
    
    struct Item {
        var id: String
        var name: String
        var price: Double
        var picName: String
    }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    Wit.sharedInstance().delegate = self
    menu.append(Item(id: "XXX", name: "hamburger", price: 5.00, picName: "hamburger"))
    menu.append(Item(id: "YYY", name: "coffee", price: 2.00, picName: "coffee"))
    menu.append(Item(id: "AAA", name: "cheeseburger", price: 5.50, picName: "cheeseburger"))
    menu.append(Item(id: "BBB", name: "french fries", price: 3.00, picName: "fries"))
    menu.append(Item(id: "CCC", name: "coke", price: 2.00, picName: "coke"))
  }

  func witDidGraspIntent(outcomes: [AnyObject]!, messageId: String!, customData: AnyObject!, error e: NSError!) {
    if (e != nil) {
      NSLog("[Wit] error: %@", e.localizedDescription)
      return
    }

    let json = JSON(outcomes as! [NSDictionary])
    NSLog("JSON: \(json.arrayValue)")

    let intent = json[0]["intent"].stringValue
    let menuItem = json[0]["entities"]["menu_item"][0]["value"].stringValue
        
    let matchedItems = menu.filter({$0.name == menuItem})
    
    if matchedItems.count == 0 {
        // no matched items
    } else {
        switch intent {
        case "add_order": items.append(matchedItems[0])
        case "delete_order":
            var index = -1
            for i in 0..<items.count {
                if items[i].name == matchedItems[0].name {
                  index = i
                }
            }
            if index > -1 {
              items.removeAtIndex(index) // remove
            }
        default: break // no defined intent error
        }
    }
    
    tableView.reloadData()
  }

  func witActivityDetectorStarted() {
//    statusView?.text = "Just listening... Waiting for voice activity"
  }

  func witDidStartRecording() {
//    statusView?.text = "Witting..."
//    entitiesView?.text = ""
  }

  func witDidStopRecording() {
//    statusView?.text = "Processing..."
//    entitiesView?.text = ""
  }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("item", forIndexPath: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
//        cell.detailTextLabel?.text = "\(item.price)"
        cell.detailTextLabel?.text = String(format: "%.2f",item.price)
        
        cell.imageView?.image = UIImage(named: item.picName)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}
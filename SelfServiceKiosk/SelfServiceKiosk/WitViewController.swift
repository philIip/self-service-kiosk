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
    menu.append(Item(id: "XXX", name: "hamburger", price: 7500, picName: "hamburger"))
    menu.append(Item(id: "YYY", name: "coffee", price: 200, picName: "coffee"))
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
    
    let matchedItem = items.filter({$0.name == menuItem})
    
//    NSLog(matchedItems);
    
    if matchedItem.count == 0 {
        NSLog("here");
    } else {
        switch intent {
        case "add_order": items.append(matchedItem[0])
        case "delete_order": break // remove
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
        cell.detailTextLabel?.text = "\(item.price)"
        cell.imageView?.image = UIImage(named: item.picName)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}
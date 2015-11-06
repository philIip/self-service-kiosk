//
//  WitViewController.swift
//  SelfServiceKiosk
//
//  Created by Yusuf on 11/5/15.
//  Copyright © 2015 Clover. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Wit


class WitViewController: UIViewController, WitDelegate {
  var statusView: UILabel?
  var intentView: UILabel?
  var entitiesView: UITextView?
  var witButton: WITMicButton?

  override func viewDidLoad() {
    super.viewDidLoad()
    Wit.sharedInstance().delegate = self
    setupUI()
  }

  func setupUI() {
    // create the button
    let screen: CGRect = UIScreen.mainScreen().bounds
    let w: CGFloat = 100
    let rect: CGRect = CGRectMake(screen.size.width/2 - w/2, 60, w, 100)

    witButton = WITMicButton.init(frame: rect)
    view.addSubview(witButton!)

    // create the label
    intentView = UILabel.init(frame: CGRectMake(0, 200, screen.size.width, 50))
    intentView?.textAlignment = NSTextAlignment.Center
    entitiesView = UITextView.init(frame: CGRectMake(0, 250, screen.size.width, screen.size.height - 300))
    entitiesView?.backgroundColor = UIColor.lightGrayColor()
    view.addSubview(entitiesView!)
    view.addSubview(intentView!)
    intentView?.text = "Intent will show up here"
    // entitiesView?.textAlignment = NSTextAlignment.Center
    entitiesView?.text = "Entities will show up here"
    entitiesView?.editable = false
    entitiesView?.font = UIFont.systemFontOfSize(17)

    statusView = UILabel.init(frame: CGRectMake(0, 150, screen.size.width, 50))
    statusView?.textAlignment = NSTextAlignment.Center
    view.addSubview(statusView!)
  }

  func witDidGraspIntent(outcomes: [AnyObject]!, messageId: String!, customData: AnyObject!, error e: NSError!) {
    if (e != nil) {
      NSLog("[Wit] error: %@", e.localizedDescription)
      return
    }

    let json = JSON(outcomes as! [NSDictionary])
    NSLog("JSON: \(json.arrayValue)")

    let intent = json[0]["intent"].stringValue
    let firstEntity = json[0]["entities"]["menu_item"][0]["value"].stringValue

    intentView?.text = "intent = \(intent)"
    statusView?.text = ""
    entitiesView?.text = "\(json.arrayValue)"

    NSLog("firstEntity: \(firstEntity)")

  }

  func witActivityDetectorStarted() {
    statusView?.text = "Just listening... Waiting for voice activity"
  }

  func witDidStartRecording() {
    statusView?.text = "Witting..."
    entitiesView?.text = ""
  }

  func witDidStopRecording() {
    statusView?.text = "Processing..."
    entitiesView?.text = ""
  }
}
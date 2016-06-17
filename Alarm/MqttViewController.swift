//
//  MqttViewController.swift
//  Alarm
//
//  Created by Raymond on 2016-06-16.
//  Copyright © 2016 Raymond. All rights reserved.
//

import UIKit
import CocoaMQTT

class MqttViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let mqttCli = CocoaMQTTCli()
        let clientIdPid = "CocoaMQTT-" + String(NSProcessInfo().processIdentifier)
        let mqtt = CocoaMQTT(clientId: "", host: "localhost", port: 1883)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
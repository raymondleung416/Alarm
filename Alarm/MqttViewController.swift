//
//  MqttViewController.swift
//  Alarm
//
//  Created by Raymond on 2016-06-16.
//  Copyright © 2016 Raymond. All rights reserved.
//

import UIKit
import CocoaMQTT

class MqttViewController: UIViewController, CocoaMQTTDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let clientIdPid = "CocoaMQTT-" + String(NSProcessInfo().processIdentifier)
        let mqtt = CocoaMQTT(clientId: clientIdPid, host: "m12.cloudmqtt.com", port: 17922)
        mqtt.username = "raymond"
        mqtt.password = "qwert"
        mqtt.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
        mqtt.keepAlive = 90
        mqtt.delegate = self
        mqtt.connect()
//        mqtt.subscribe("test")
//        mqtt.ping()
        mqtt.publish("test", withString: "Hello")
        
//        dispatch_main()
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
    

    // MARK: - CocoaMQTTDelegate
    
    func mqtt(mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        debugPrint(["did connect: ", host, port])
    }
    
    func mqtt(mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck){
        debugPrint("did connect ack: ")
        if ack == .ACCEPT {
            mqtt.subscribe("test")
        }
    }
    
    func mqtt(mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        debugPrint(["did publish message: ", message])
    }
    
    func mqtt(mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        debugPrint("did publish ack: ")
    }
    
    func mqtt(mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        debugPrint(["did receive message: ", message])
    }
    
    func mqtt(mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        debugPrint(["did subscribe topic: ", topic])
    }
    
    func mqtt(mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        debugPrint(["did unsubscribe topic: ", topic])
    }
    
    func mqttDidPing(mqtt: CocoaMQTT) {
        debugPrint("did ping")
    }
    
    func mqttDidReceivePong(mqtt: CocoaMQTT) {
        debugPrint("did receive pong")
    }
    
    func mqttDidDisconnect(mqtt: CocoaMQTT, withError err: NSError?) {
        debugPrint("did disconnect")
    }

    
}

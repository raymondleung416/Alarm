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

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    var mqtt: CocoaMQTT?
    
    var messages: [String] = [] {
        didSet {
            tableView.reloadData()
            scrollToBottom()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        tableView.dataSource = self;
        tableView.delegate = self;

        connectMQTT()
        
//        dispatch_main()
    }

    deinit {
        mqtt?.disconnect()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendMessage(sender: AnyObject) {
        if let text = inputTextField.text {
            mqtt?.publish("test", withString: text)
            inputTextField.text = ""
        }
        
    }
    
    func scrollToBottom() {
        let count = messages.count
        if count > 3 {
            let indexPath = NSIndexPath(forRow: count - 1, inSection: 0)
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
        }
    }

}


// MARK: - TableView DataSource and Delegate

extension MqttViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MQTTCell")
        cell!.textLabel?.text = messages[indexPath.row]
        return cell!;
    }
}

// MARK: - CocoaMQTTDelegate

extension MqttViewController: CocoaMQTTDelegate {
    
    func connectMQTT() {
        let clientIdPid = "CocoaMQTT-" + String(NSProcessInfo().processIdentifier)
        mqtt = CocoaMQTT(clientId: clientIdPid, host: "m12.cloudmqtt.com", port: 17922)
        mqtt?.username = "raymond"
        mqtt?.password = "qwert"
        mqtt?.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
        mqtt?.keepAlive = 90
        mqtt?.delegate = self
        mqtt?.connect()
        //        mqtt.subscribe("test")
        //        mqtt.ping()
        //mqtt.publish("test", withString: "Hello")
    }
    
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
        debugPrint(["did publish message: ", message.topic, message.string])
    }
    
    func mqtt(mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        debugPrint("did publish ack: ")
    }
    
    func mqtt(mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        debugPrint(["did receive message: ", message.topic, message.string])
        messages.append(message.string!);
        tableView.reloadData();
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

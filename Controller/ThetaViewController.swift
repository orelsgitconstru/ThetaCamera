//
//  ViewController.swift
//  ThetaCamera
//
//  Created by אוראל זילברמןֿ on 09/01/2022.
//

import UIKit

class ViewController: UIViewController, ThetaManagerDelegateProtocol {
    
    @IBOutlet weak var ipLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var ipTextFIeld: UITextField!
    var thetaManager = ThetaManager()
    var ip = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ipLabel.text = thetaManager.baseURL
        thetaManager.delegate = self
    }
    
    func setData(string: String){
        DispatchQueue.main.async {
            print("preset")
            self.dataLabel.text = "battery: \(string)"
            print("postset")
        }
    }
    
    @IBAction func onTakePicturePress(_ sender: UIButton) {
        if(ip == "")
        {
            thetaManager.takePhoto(baseURL: thetaManager.thetaURL)
            ipLabel.text = thetaManager.thetaURL
        } else {
            thetaManager.takePhoto(baseURL: "http://\(ip)")
            ipLabel.text = "http://\(ip)"
        }
    }
    
    
    
    @IBAction func connectButton(_ sender: UIButton) {
//        var ip = thetaManager.thetaURL
        if(ip == "") {
            ip = "192.168.1.1"
        }
        ipTextFIeld.endEditing(true)
        ipLabel.text = ip
    }
    @IBAction func ipEditingDidEnd(_ sender: UITextField) {
        ip = sender.text!
        ipLabel.text = ip
    }

    @IBAction func getStatePressed(_ sender: UIButton) {
        thetaManager.getState(baseURL: ip)
    }
}


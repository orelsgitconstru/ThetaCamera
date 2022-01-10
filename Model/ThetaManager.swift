//
//  ThetaManager.swift
//  ThetaCamera
//
//  Created by אוראל זילברמןֿ on 09/01/2022.
//

import Foundation

struct ThetaManager{
    var baseURL: String {
        return "http://\(getWiFiAddress()!)"
    }
    let takePhotoURL = "/osc/commands/execute"
    let getState = "/osc/state"
    
    var delegate: ThetaManagerDelegateProtocol? = nil
    
    var thetaURL: String {
        return "http://\(getWiFiAddress() ?? "192.168.1.1")"
    }
    
    func takePhoto(){
        let url = "\(baseURL)\(takePhotoURL)"
        performRequest(with: url)
    }
    
    func takePhoto(baseURL: String){
        let url = "\(baseURL)\(takePhotoURL)"
        print(url)
        performRequest(with: url)
    }
    
    func getState(baseURL: String) {
        let url = "http://\(baseURL)\(getState)"
        print(url)
        performRequest(with: url)
    }
    
    func performRequest(with url: String){
        if let urlObject = URL(string :url){
            var urlRequest = URLRequest(url: urlObject)
            urlRequest.addValue("application/json; charaset=utf-8", forHTTPHeaderField: "Content-Type")
            urlRequest.httpMethod = "POST"
  
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    if let stateJSON = responseJSON["state"] as? [String:Any] {
                        let batteryLevel = String(format: "%.2f", ((stateJSON["batteryLevel"] as! Double) * 100))
                        delegate?.setData(string: batteryLevel)
                    }
                }
            }
//            let task = session.dataTask(with: urlObject, completionHandler: handleRequest)
            task.resume()
        }
    }
    
    func handleRequest(data: Data?, urlResponse: URLResponse?, error: Error?) {
        print("")
//        if(error != nil){
//            delegate?.didFailWithError(self, error: error!)
//            return
//        }
//        if let safeData = data {
//            if let weather = parseJSON(safeData){
//                delegate?.didUpdateWeather(self, weather: weather)
//            }
//        }
    }
    
    func getWiFiAddress() -> String? {
        var address : String?

        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }

        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee

            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {

                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
//        return "192.168.1.5"
    }
}

protocol ThetaManagerDelegateProtocol{
    func setData(string: String)
}

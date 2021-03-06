//
//  ViewController.swift
//  NSURLSessionUpload
//
//  Created by Gemtek iOS team on 11/5/14.
//  Copyright (c) 2014 Sam Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate {

    
    let accessToken = "+1gC70EnpV7yZlrJUK4PfPmclT8kEIpCzfXCu/JMfGFjpMPvUg7wRHeWvaLTA9zk"

    var link = ""
    var responseData = NSMutableData()
    @IBOutlet weak var progressView: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
     
    //    uploadActualFile()
        getSignedURL()
    }
    
    
    func uploadActualFile(jsonStr: String){

        
        
        
        let bundle = NSBundle.mainBundle()
        let path = bundle.pathForResource("greenbright01", ofType: "png")
        var data: NSData = NSData(contentsOfFile: path!)!
        
        
        // IMPORTANT : THIS URL HAS TO BE REQUESTED LIKE THIS:
        
        //  var signed_query_result = sqor.Util.getSignedUrlAmazon("image", "jpg", "image/jpeg");
        
        
        
        
        // REMOVE STUPID " from start and end
        
        let str : String = jsonStr
        let realURL =  str.substringWithRange(Range<String.Index>(start: advance(str.startIndex, 1), end: advance(str.endIndex, -1)))
        println("OMG OMG OMG")
        println("OMG OMG OMG")
        
        
        
        println(realURL)
        
        self.link = realURL
        let url = NSURL(string: realURL)
        
        
        var request = NSMutableURLRequest(URL: url! )
        request.HTTPMethod = "PUT"
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        
        
        
     //   request.setValue("Content-Type", forHTTPHeaderField: "image/jpeg")
        
      //  let accessToken = "PRppT0hm6ZkDf9OvtfufPWqiH/zsY2npspRL3iBZwTNVOs8cV0HIwAytbH782l0J"
      //  request.addValue(accessToken , forHTTPHeaderField: "access-token")
        
        request.setValue("image/png", forHTTPHeaderField: "Content-Type")
        uploadFiles(request, data: data)
       
        
        
        
      
    }
    
    
    
    func uploadFiles(  request: NSURLRequest, data: NSData) {
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        var session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        var task = session.uploadTaskWithRequest(request, fromData: data)
        task.resume()
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if error != nil {
            println("session \(session) occurred error \(error?.localizedDescription)")
        } else {
            println("session \(session) upload completed, response: \(NSString(data: responseData, encoding: NSUTF8StringEncoding))")
            
            
            
            makePost()
        }
    }
    
    
    func makePost(){
        
        
        
        
        println("submitting post")
        
        // if blank dont submit
        
        

        
        
        var request = NSMutableURLRequest(URL: NSURL(string: "https://rest-dev.sqor.com/posts")!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        
  
        
        
   

        

        
        println("ACTUAL POST URL ")
  
  
        var fullNameArr = split(self.link) {$0 == "?"}
        var link : String = fullNameArr[0]
        
        
        println(link)
        
                println("ACTUAL POST URL ")
        let json_Str = "{\"content\": \"ok3 why name a wankster\", \"media\" : [{\"contentType\":\"image/png\",\"ext\":\"png\",\"link\":\""
        +
            link +
            
        "\",\"name\":\"image.png\",\"type\":\"image\"}]}"   //NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        println(json_Str)
        println(" JSON OBJ")
        
        //let json_Str = "{\"content\": \"ok2 yy\" }"
        
        let jsonData   = (json_Str as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = jsonData
        
        
        
        
        var err: NSError?
        //request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //  request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(accessToken , forHTTPHeaderField: "access-token")
        request.addValue("6", forHTTPHeaderField: "sqor-api-version")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            println("WTF WHY IS THIS FAILIN----------------")
            
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    var success = parseJSON["success"] as? Int
                    println("Succes: \(success)")
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                }
            }
        })
        
        task.resume()
        
        
    }
    
    
    
    
    
    
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        var uploadProgress: Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        println("session \(session) uploaded \(uploadProgress * 100)%.")
        progressView.progress = uploadProgress
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        println("session \(session), received response \(response)")
        completionHandler(NSURLSessionResponseDisposition.Allow)
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        responseData.appendData(data)
    }
    
    
    
    
    func getSignedURL(){
        
        println("submitting post")
        
        // if blank dont submit
        
        
        
        
        
        
        var request = NSMutableURLRequest(URL: NSURL(string: "https://rest-dev.sqor.com/posts/upload")!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
    
        
        //   let tbController = self.tabBarController as HomeTabBarController;
        //  let userData = tbController.userData;
        //  let accessToken = userData.valueForKey("access_token") as String;
        
        
        var params = ["content_type": "image/png",
            "file_extension": "png",
            "media_type": "image"   ] as Dictionary<String, String>
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //  request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(accessToken , forHTTPHeaderField: "access-token")
        request.addValue("6", forHTTPHeaderField: "sqor-api-version")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData!)")
            
            println("WTF WTF WTF ")
            
            self.uploadActualFile(strData!)
            println("WTF WTF WTF ")
            
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            
            
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("XXXX Error could not parse JSON: '\(jsonStr)'")
             
                
                
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    var success = parseJSON["success"] as? Int
                    println("Succes: \(success)")
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    
                    
                 //  println("Error could not parse JSON: \(jsonStr)")
                 //   print("SUCCESS!!!: ")
                //    print(jsonStr)
                    
                
                    
                }
            }
        })
        
        task.resume()
        
        

    }
    
    
    
}


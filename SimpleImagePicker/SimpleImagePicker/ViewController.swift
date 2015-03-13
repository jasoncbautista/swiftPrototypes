//
//  ViewController.swift
//  SimpleImagePicker
//
//  Created by Sqor Admin on 3/12/15.
//  Copyright (c) 2015 Sqor. All rights reserved.
//


import MobileCoreServices

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,  NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate {
    
    let accessToken = "+1gC70EnpV7yZlrJUK4PfPmclT8kEIpCzfXCu/JMfGFjpMPvUg7wRHeWvaLTA9zk"
    
    var link = ""
    var responseData = NSMutableData()
    
    var globalImageData: NSData?
    
    
   //@IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myImageView: UIImageView!
    let picker = UIImagePickerController()   //our controller.


    
    //Memory will be conserved a bit if you place this in the actions.
    // I did this to make code a bit more streamlined
    
    //MARK: - Methods
    // An alert method using the new iOS 8 UIAlertController instead of the deprecated UIAlertview
    // make the alert with the preferredstyle .Alert, make necessary actions, and then add the actions.
    // add to the handler a closure if you want the action to do anything.
    
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style:.Default, handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC, animated: true, completion: nil)
    }
    
    //MARK: - Actions
    //get a photo from the library. We present as a popover on iPad, and fullscreen on smaller devices.
    @IBAction func photoFromLibrary(sender: UIBarButtonItem) {


        println("GETTING PHOTO FROM LIBRARY")
        
    }
    
    
    @IBOutlet weak var barButton2: UIBarButtonItem!
    
    
    
    @IBAction func photoFromLIb2(sender: UIButton) {
        
        
        picker.allowsEditing = false //2
        picker.sourceType = .PhotoLibrary //3
      //  picker.mediaTypes =  [kUTTypeImage]
        picker.mediaTypes =  [kUTTypeImage, kUTTypeMovie]
        
        picker.modalPresentationStyle = .Popover
        presentViewController(picker, animated: true, completion: nil)//4
        picker.popoverPresentationController?.barButtonItem = barButton2
        
    }
    
    /*
    @IBAction func photoFromLib(sender: UIBarButtonItem) {
        
        
        picker.allowsEditing = false //2
        picker.sourceType = .PhotoLibrary //3
        picker.modalPresentationStyle = .Popover
        presentViewController(picker, animated: true, completion: nil)//4
        picker.popoverPresentationController?.barButtonItem = sender
        
        
        
    }
*/
    //take a picture, check if we have a camera first.
    @IBAction func shootPhoto(sender: UIBarButtonItem) {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = .Photo
            presentViewController(picker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        picker.delegate = self   //the required delegate to get a photo back to the app.
    }
    
    


    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        
        
        let mediaType = info[UIImagePickerControllerMediaType] as NSString
        
        if mediaType.isEqualToString(kUTTypeImage as NSString) {
            println("IMAGE!!!!!!")
            // Media is an image
            
            self.contentType = "image/png"
            
            self.mediaType = "image"
            self.fileExtension = "png"
        
        
            var chosenImage = info[UIImagePickerControllerOriginalImage] as UIImage //2
            myImageView.contentMode = .ScaleAspectFit //3
            myImageView.image = chosenImage //4
            
            var nsDataImage = UIImagePNGRepresentation(chosenImage)
            dismissViewControllerAnimated(true, completion: nil) //5
            
            println("PICKED PHOTO")
            
            
            
            self.globalImageData = nsDataImage
            
            getSignedURL()
            //  println(    nsDataImage.description)
        
        } else if mediaType.isEqualToString(kUTTypeMovie as NSString) {
            
            // Media is a video
            
            self.contentType = "video/quicktime"
            
            self.mediaType = "video"
            self.fileExtension = "mov"
            println("VIDEO")
            
            // TODO: make video picking possible
            
            var chosenImage =   info[UIImagePickerControllerMediaURL]   as NSURL // as UIImage //2
            
            
            var nsDataImage = NSData(contentsOfURL: chosenImage, options: nil, error: nil)
            
            //   myImageView.contentMode = .ScaleAspectFit //3
            //   myImageView.image = chosenImage //4
            
            //        var nsDataImage = chosenImage
            // UIImagePNGRepresentation(chosenImage)
            dismissViewControllerAnimated(true, completion: nil) //5
            
            println("PICKED PHOTO")
            
            
            //  nsDataImage.data
            
            self.globalImageData = nsDataImage
            
            println("NS URL: ")
            println(chosenImage)
            
            
        }
        
        
        
        

        getSignedURL()
        //  println(    nsDataImage.description)
    }
    
    
    
    
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func uploadActualFile(jsonStr: String){
        
        
        
        
       //let bundle = NSBundle.mainBundle()
        //let path = bundle.pathForResource("greenbright01", ofType: "png")
        var data: NSData =   self.globalImageData! //NSData(contentsOfFile: path!)!
        
        
        // IMPORTANT : THIS URL HAS TO BE REQUESTED LIKE THIS:
        
      
        
        
        
        // REMOVE STUPID " from start and end
        
        let str : String = jsonStr
        
        println(str)
        println("STRING ^")
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
        
        request.setValue(self.contentType, forHTTPHeaderField: "Content-Type")
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
    
    
    var postValue = "Sample Post"
    func makePost(){
    
        println("submitting post")
        
        // TODO: if blank dont submit
        var request = NSMutableURLRequest(URL: NSURL(string: "https://rest-dev.sqor.com/posts")!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
    
        
        println("ACTUAL POST URL ")
        
        
        var fullNameArr = split(self.link) {$0 == "?"}
        var link : String = fullNameArr[0]
        
        
        println(link)
        
        println("ACTUAL POST URL ")
        let json_Str = "{\"content\": \"" + postValue + "\", \"media\" : [{\"contentType\":\"" + contentType + "\",\"ext\":\"" + fileExtension + "\",\"link\":\""
            +
            link +
            
        "\",\"name\":\"video.mov\",\"type\":\"" + mediaType + "\"}]}"   //NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
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
       // progressView.progress = uploadProgress
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        println("session \(session), received response \(response)")
        completionHandler(NSURLSessionResponseDisposition.Allow)
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        responseData.appendData(data)
    }
    
    
    
    var contentType: String =  "movie/quicktime"
    var fileExtension: String = "mov"
    
    var mediaType: String = "video"
    
    func getSignedURL( ){
        
        println("submitting post")
        
        // if blank dont submit
        

        var request = NSMutableURLRequest(URL: NSURL(string: "https://rest-dev.sqor.com/posts/upload")!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        
        
        //   let tbController = self.tabBarController as HomeTabBarController;
        //  let userData = tbController.userData;
        //  let accessToken = userData.valueForKey("access_token") as String;
        
        
        var params = ["content_type": contentType,
            "file_extension": fileExtension,
            "media_type": mediaType   ] as Dictionary<String, String>
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //  request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(accessToken , forHTTPHeaderField: "access-token")
        request.addValue("6", forHTTPHeaderField: "sqor-api-version")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
      
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)

            self.uploadActualFile(strData!)

        })
        
        task.resume()
        
        
        
    }
    
}
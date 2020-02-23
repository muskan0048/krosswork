import UIKit
import Flutter
import Razorpay
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,RazorpayPaymentCompletionProtocol {
    
  var resultBack: FlutterResult?
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController;
    
    
    let printChannel = FlutterMethodChannel.init(name: "flutter.appyflow.in.channel",
                                                 binaryMessenger: controller);
    printChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        
        self.resultBack = result
        
        //        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        //
        //        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "print")
        //        self.window?.rootViewController=nextViewController
        //
        ////        let appdele = UIApplication.shared.delegate as! AppDelegate
        ////        appdele.window?.rootViewController = nextViewController
        //
            print("Hello")
        
        
        self.showPaymentForm(call:call)
        
//        let printController = UIPrintInteractionController.shared
//        // 2
//        let printInfo = UIPrintInfo(dictionary:nil)
//        printInfo.outputType = UIPrintInfoOutputType.general
//        printInfo.jobName = "print Job"
//        printController.printInfo = printInfo
//
//
//
//        let text = call.arguments as! String
//
//        // 3
//        let formatter = UIMarkupTextPrintFormatter(markupText: ""+text)
//
//        formatter.perPageContentInsets = UIEdgeInsets(top: 72, left: 72, bottom: 72, right: 72)
//        printController.printFormatter = formatter
//
//        // 4
//        printController.present(animated: true, completionHandler:nil)
//
//
//        result("succes")
//
        
        
    });
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    internal func showPaymentForm(call: FlutterMethodCall){
        var razorpay: Razorpay!
        razorpay = Razorpay.initWithKey("rzp_live_MQdGY7MHT10ZNd", andDelegate: self)
        
        let arguments=call.arguments as! NSDictionary
        let txnId=arguments["txnId"] as! String
        let userPhone=arguments["userPhone"] as! String
        let pInfo=arguments["pInfo"] as! String
        let userName=arguments["userName"] as! String
        let amount=arguments["amount"] as! String
        let userEmail=arguments["userEmail"] as! String
        
        
        let options: [String:Any] = [
            "amount" : "\(Double(amount)!*100)",
            "description": pInfo,
            "image": "https://appyflow.in/img/blogapp.png",
            "name": "Splash WorkSpaces",
            "prefill": [
                "contact": userPhone,
                "email": userEmail
            ],
            "theme": [
                "color": "#007AFF"
            ]
        ]
        razorpay.open(options)
    }
    
    public func onPaymentError(_ code: Int32, description str: String){
        
        
        
        print(str)
        
        var hashMap = [String : Any]()
        
        
        hashMap["status"] = 1
        hashMap["paymentId"] = ""
        
        
        self.resultBack!(hashMap);
        
//        let alertController = UIAlertController(title: "FAILURE", message: str, preferredStyle: UIAlertController.Style.alert)
//        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
//        alertController.addAction(cancelAction)
//        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    public func onPaymentSuccess(_ payment_id: String){
        
        print("Payment Id \(payment_id)")
        
        var hashMap = [String : Any]()
        
        
        hashMap["status"] = 3
        hashMap["paymentId"] = payment_id
        
        self.resultBack!(hashMap)
        
        
        
//        let alertController = UIAlertController(title: "SUCCESS", message: "Payment Id \(payment_id)", preferredStyle: UIAlertController.Style.alert)
//        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
//        alertController.addAction(cancelAction)
//        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}

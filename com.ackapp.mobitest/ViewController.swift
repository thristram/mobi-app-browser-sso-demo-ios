//
//  ViewController.swift
//  com.ackapp.mobitest
//
//  Created by Li, Fang on 4/13/22.
//

import UIKit
import WebKit
import AuthenticationServices
import SafariServices

class ViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding, SFSafariViewControllerDelegate {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
    
    
    var redirectURI: String?
    var browser: String = "Unknown"
    var SFWebview: SFSafariViewController? = nil

    @IBOutlet weak var browserLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var webview: WKWebView!
    @IBAction func toBrowserOld(_ sender: Any) {
        
        let urlString:String = "https://mobileidentity.ackapp.com/testpb?key=value#identity_sso_auth_code=ANcQCfuDcNsVmQqsyoNyCtblz"
        let url = URL(string: urlString)

        if let _ = url {
            if UIApplication.shared.canOpenURL(url!){
                print("Can Open URL")
                UIApplication.shared.open(url!)
            }   else    {
                
                print("Cannot Open URL")
            }

        }
    }
    @IBAction func toBrowserButton(_ sender: Any) {
        let urlString:String = "https://mobileidentity.ackapp.com/testpb#identity_sso_auth_code=ANcQCfuDcNsVmQqsyoNyCtblz"

        let url = URL(string: urlString)

        if let _ = url {
            if UIApplication.shared.canOpenURL(url!){
                print("Can Open URL")
                UIApplication.shared.open(url!)
            }   else    {
                
                print("Cannot Open URL")
            }

        }

//
//        switch self.browser{
//        case "Safari":
//            if let url = URL(string: self.redirectURI ?? defaultURL) {
//                UIApplication.shared.open(url)
//            }
//            break
//        case "Chrome":
//            var newLink: String = self.redirectURI ?? defaultURL
//            newLink = newLink.replacingOccurrences(of: "https://", with: "googlechrome://https://")
//            print(newLink)
//            if  UIApplication.shared.canOpenURL(URL(string: newLink)!) {
//                UIApplication.shared.open(URL(string: newLink)!)
//            }
//            break
//        default:
//            break
//        }
        
    }
    
    @IBAction func initWebAuthN(_ sender: Any) {
        self.SFWebview = SFSafariViewController(url: URL(string: "https://mobileidentity.ackapp.com/ivvtest")!)
        self.SFWebview?.delegate = self
        present(self.SFWebview!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did load")
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.getDeeplinkURL(_:)), name: NSNotification.Name(rawValue: "getDeekLinkURI"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissIVV(_:)), name: NSNotification.Name(rawValue: "dismissIVV"), object: nil)
        self.setBrowserValue()
        
        
        let htmlFile = Bundle.main.path(forResource: "index", ofType: "html")
        let html = try! String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
       
    }
    
    @objc func dismissIVV (_ notification: Notification){
        self.SFWebview?.dismiss(animated: true)
    }
    
    @objc func getDeeplinkURL(_ notification: Notification){
        redirectURI = notification.userInfo?["redirectURI"] as? String ?? ""
        browser = notification.userInfo?["browser"] as? String ?? ""
        self.setBrowserValue()
        
        print("redirectURI = \(self.redirectURI ?? "Not Set")")
        print("browser = \(browser)")
    }
    func setBrowserValue (){
        self.browserLabel.text = "Browser: \(browser)"
        self.urlLabel.text = "redirectURI: \(self.redirectURI ?? "Not Set")"
    }
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL){
        print(1)
        if URL.absoluteString == "https://mobileidentity.ackapp.com/ivvlanding" {
            self.SFWebview!.dismiss(animated: true)
        }
            
    }
   
}


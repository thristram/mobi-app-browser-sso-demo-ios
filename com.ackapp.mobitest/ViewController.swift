//
//  ViewController.swift
//  com.ackapp.mobitest
//
//  Created by Li, Fang on 4/13/22.
//

import UIKit
import WebKit
import AuthenticationServices

class ViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
    
    
    var redirectURI: String?
    var browser: String = "Unknown"

    @IBOutlet weak var browserLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var webview: WKWebView!
    @IBAction func toBrowserButton(_ sender: Any) {
        let defaultURL: String = "https://mobileidentity.ackapp.com"
        
        
        switch self.browser{
        case "Safari":
            if let url = URL(string: self.redirectURI ?? defaultURL) {
                UIApplication.shared.open(url)
            }
            break
        case "Chrome":
            var newLink: String = self.redirectURI ?? defaultURL
            newLink = newLink.replacingOccurrences(of: "https://", with: "googlechrome://https://")
            print(newLink)
            if  UIApplication.shared.canOpenURL(URL(string: newLink)!) {
                UIApplication.shared.open(URL(string: newLink)!)
            }
            break
        default:
            break
        }
        
    }
    
    @IBAction func initWebAuthN(_ sender: Any) {
        var challenge : Data = Data()
        let platformProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: "redirect.ackapp.com")
        let platformKeyRequest = platformProvider.createCredentialAssertionRequest(challenge: challenge)
        let authController = ASAuthorizationController(authorizationRequests: [platformKeyRequest])
        
        authController.delegate = self
        authController.presentationContextProvider = self
        authController.performRequests()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did load")
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.getDeeplinkURL(_:)), name: NSNotification.Name(rawValue: "getDeekLinkURI"), object: nil)
        self.setBrowserValue()
        
        
        let htmlFile = Bundle.main.path(forResource: "index", ofType: "html")
        let html = try! String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
        self.webview.loadHTMLString(html, baseURL: nil)
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
    
   
}


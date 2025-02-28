//
//  ViewController.swift
//  IntuneRemediationFlow
//
//  Created by vinay kumar on 13/02/25.
//

import UIKit
import MSAL
import IntuneMAMSwift



class ViewController: UIViewController {
    
    private var msalApplication: MSALPublicClientApplication?
    
    let kClientID = "9794dec7-21df-48e9-8504-e4a01adf63f3"
    let kRedirectUri = "msauth.com.test.IntuneRemediationFlow1://auth"
    let kAuthority = "https://login.microsoftonline.com/organizations"
    let scopes = ["https://graph.microsoft.com/InformationProtectionPolicy.Read"]
    private var accoundID: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initializeMSAL()
        signInButton()
        signOutButton()
        
        intuneLogsButton()
    }
    
    private func initializeMSAL() {
        do {
            let authority = try? MSALAuthority(url: URL(string: kAuthority)!)
            let config = MSALPublicClientApplicationConfig(clientId: kClientID, redirectUri: kRedirectUri, authority: authority)
            config.clientApplicationCapabilities = ["ProtApp"]
            
            self.msalApplication = try MSALPublicClientApplication(configuration: config)
            
            IntuneMAMSettings.aadClientIdOverride = kClientID
            IntuneMAMSettings.aadAuthorityUriOverride = kAuthority
            IntuneMAMSettings.aadRedirectUriOverride = kRedirectUri
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    private func signInButton() {
        // Create a button
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Add action to button
        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        
        // Add button to the view
        view.addSubview(button)
        
        // Set constraints to center the button
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func signOutButton() {
        // Create a sign-out button
        let button = UIButton(type: .system)
        button.setTitle("Sign Out", for: .normal)
        button.backgroundColor = UIColor.systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false

        // Add action to button
        button.addTarget(self, action: #selector(signOut), for: .touchUpInside)

        // Add button to the view
        view.addSubview(button)

        // Set constraints to place the button below the Sign In button
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 70), // Positioned below Sign In
            button.widthAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func intuneLogsButton() {
        // Create a logs button
        let button = UIButton(type: .system)
        button.setTitle("Intune Logs", for: .normal)
        button.backgroundColor = UIColor.systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false

        // Add action to button
        button.addTarget(self, action: #selector(intuneLogs), for: .touchUpInside)

        // Add button to the view
        view.addSubview(button)

        // Set constraints to place the button below the Sign In button
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 140), // Positioned below Sign In
            button.widthAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func signIn() {
        guard let msalApplication = msalApplication else {
            print("call initializeMSAL before using msalApplication")
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            
            guard let strongSelf = self else {
                print("self is nil")
                return
            }
            
            let webParameters = MSALWebviewParameters(authPresentationViewController: strongSelf)
            
            let interactiveParameters = MSALInteractiveTokenParameters(scopes: strongSelf.scopes, webviewParameters: webParameters)
            interactiveParameters.promptType = .selectAccount
            
            msalApplication.acquireToken(with: interactiveParameters) { result, error in
                guard let authResult = result, error == nil else {
                    let nsError = error! as NSError
                    if nsError.domain == MSALErrorDomain, let errorCode = MSALError(rawValue: nsError.code)
                    {
                        switch errorCode
                        {
                        case .serverProtectionPoliciesRequired:
                            // Integrate the Intune SDK and call the
                            // remediateComplianceForIdentity:silent: API.
                            // Handle this error only if you integrated Intune SDK.
                            // See more info here: https://aka.ms/intuneMAMSDK
                            let homeAccoundId = nsError.userInfo[MSALHomeAccountIdKey] as! String
                            let oid = homeAccoundId.components(separatedBy: ".").first ?? ""
                            self?.accoundID = String(oid)
//                            self?.showAlert(title: "serverProtectionPoliciesRequired", message: "\(nsError.userInfo[MSALErrorDescriptionKey] ?? "No Error")")
                            print("received serverProtectionPoliciesRequired")
//                            Old Flow
//                            IntuneMAMComplianceManager.instance().remediateCompliance(forAccountId: String(oid), silent: false)
//                            New Flow
                            MAMComplianceDelegate.shared.performIntuneRemediation(for: String(oid), silent: false) { message in
                                print("\(message) in performIntuneRemediation")
                            }
                            break
                        default:
                            print("Failed with unknown MSAL error \(error?.localizedDescription ?? "No Error")")
//                            self?.showAlert(title: "unknown error", message: "\(error?.localizedDescription ?? "No Error")")
                        }
                    }
                    return
                }
                self?.accoundID = authResult.tenantProfile.identifier
                print("success token: \(authResult.accessToken)")
//                self?.showAlert(title: "Signed In", message: "\(self?.accoundID ?? "No Account")")
            }
        }
    }
    
    @objc func signOut() {
        guard let accountId = accoundID else {
            print("account id not found")
            return
        }
        IntuneMAMEnrollmentManager.instance().deRegisterAndUnenrollAccountId(accountId, withWipe: true)
    }
    
    @objc func intuneLogs() {
        IntuneMAMDiagnosticConsole.display()
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    
    
}

//extension ViewController: IntuneMAMEnrollmentDelegate, IntuneMAMPolicyDelegate {
//    func restartApplication() -> Bool {
//        return true
//    }
//    
//    func wipeData(forAccountId accountId: String) -> Bool {
//        return true
//    }
//    
//    func enrollmentRequest(with status: IntuneMAMEnrollmentStatus) {
//        print(status.statusCode, status.errorString ?? "No error", "enrollmentRequest")
////        showAlert(title: "Enrollment Request", message: "Status: \(status.statusCode) error: \(status.errorString ?? "No error")")
//    }
//    
//    func unenrollRequest(with status: IntuneMAMEnrollmentStatus) {
//        print(status.statusCode, status.errorString ?? "No error", "unenrollRequest")
////        showAlert(title: "UnEnrollment Request", message: "Status: \(status.statusCode) error: \(status.errorString ?? "No error")")
//    }
//}


//
//  MAMComplianceDelegate.swift
//  IntuneRemediationFlow
//
//  Created by vinay kumar on 20/02/25.
//

import Foundation
import IntuneMAMSwift

class MAMComplianceDelegate: NSObject, IntuneMAMComplianceDelegate {
    static let shared = MAMComplianceDelegate()
    
    func performIntuneRemediation(for identity: String, silent: Bool, continueBlock: ((String)->())) {
        if IntuneMAMComplianceManager.instance().remediationInProgress(forAccountId: identity) {
            continueBlock("Registration for the user \(identity) in in progress, ignore new action")
        } else {
            IntuneMAMComplianceManager.instance().remediateCompliance(forAccountId: identity, silent: silent)
        }
    }
    
    func accountId(_ accountId: String, hasComplianceStatus status: IntuneMAMComplianceStatus, withErrorMessage errMsg: String, andErrorTitle errTitle: String) {
        print(accountId, status.rawValue, errMsg, errTitle, "IntuneMAMComplianceDelegate callback")
    }
}

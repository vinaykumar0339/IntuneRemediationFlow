//
//  MAMComplianceDelegate.swift
//  IntuneRemediationFlow
//
//  Created by vinay kumar on 20/02/25.
//

import Foundation
import IntuneMAMSwift

class MAMComplianceDelegate: NSObject, IntuneMAMComplianceDelegate {
    func accountId(_ accountId: String, hasComplianceStatus status: IntuneMAMComplianceStatus, withErrorMessage errMsg: String, andErrorTitle errTitle: String) {
        print(accountId, status.rawValue, errMsg, errTitle, "IntuneMAMComplianceDelegate callback")
    }
}

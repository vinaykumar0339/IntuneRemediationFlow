//
//  MAMPolicyDelegate.swift
//  IntuneRemediationFlow
//
//  Created by vinay kumar on 20/02/25.
//

import Foundation
import IntuneMAMSwift

class MAMPolicyDelegate: NSObject, IntuneMAMPolicyDelegate {
    func restartApplication() -> Bool {
        return true
    }
    
    func wipeData(forAccountId accountId: String) -> Bool {
        return true
    }
}

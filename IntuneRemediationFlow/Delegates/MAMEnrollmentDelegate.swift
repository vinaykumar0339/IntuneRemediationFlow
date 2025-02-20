//
//  MAMEnrollmentDelegate.swift
//  IntuneRemediationFlow
//
//  Created by vinay kumar on 20/02/25.
//

import Foundation
import IntuneMAMSwift

class MAMEnrollmentDelegate: NSObject, IntuneMAMEnrollmentDelegate {
    func enrollmentRequest(with status: IntuneMAMEnrollmentStatus) {
        print(status.statusCode, status.errorString ?? "No error", "enrollmentRequest")
    }
    
    func unenrollRequest(with status: IntuneMAMEnrollmentStatus) {
        print(status.statusCode, status.errorString ?? "No error", "unenrollRequest")
    }
}

//
//  Log.swift
//  BonjourServerDemo
//
//  Created by max kryuchkov on 24.11.2023.
//

import Foundation
import os.log

func log(_ message: String) {
    let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "MPLogging")
    os_log("%@", log: log, type: .debug, message)
}

//
//  StringExtension.swift
//  ProjectZero
//
//  Created by phing on 2019-11-13.
//  Copyright © 2019 phing. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

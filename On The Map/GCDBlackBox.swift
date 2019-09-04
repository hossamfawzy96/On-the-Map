//
//  GCDBlackBox.swift
//  On The Map
//
//  Created by Hossameldien Hamada on 8/31/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}

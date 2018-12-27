//
//  GDCBlackBox.swift
//  OnTheMapTest
//
//  Created by Gareth O'Sullivan on 27/12/2018.
//  Copyright © 2018 Locust Redemption. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}

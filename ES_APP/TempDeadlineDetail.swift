//
//  TempDeadlineDetail.swift
//  My IP Port
//
//  Created by Johannes Fuest on 11.07.22.
//

import Foundation

import SwiftUI

struct TempDeadlineView: View {
    var deadline: Deadline
    var body: some View {
        Text("Hallo, hier sollten Details zu \(deadline.occasion) stehen")
    }
}

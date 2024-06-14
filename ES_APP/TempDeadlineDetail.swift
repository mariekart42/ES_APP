
import Foundation

import SwiftUI

struct TempDeadlineView: View {
    var deadline: Deadline
    var body: some View {
        Text("Hallo, hier sollten Details zu \(deadline.occasion) stehen")
    }
}

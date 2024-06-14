
import SwiftUI

struct LoadingView: View {
    @Binding var didLoad: Bool
    
    // The View Context of the shared NSManagedObjectContext
    @Environment(\.managedObjectContext) var viewContext
    
    // The View Model responsible for updating the storage
    @EnvironmentObject private var dataViewModel: DataViewModel

    var body: some View {
        VStack {
            Spacer()
            Image("IP_Port_Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 150, alignment: .top)
                .cornerRadius(20)
            Spacer()
                
            if !didLoad {
                HStack {
            ProgressView()
                    Text("Loading Data")
                        .padding()
                }
            }
            Spacer()
        }
        .task {
            // Update the data if last update was 24 hours ago or for the nightly PatOrg Update
            if let lastUpdateDate = dataViewModel.userDefaults.object(forKey: "lastUpdateDate") as? Date {
                if lastUpdateDate.timeIntervalSinceNow < -86400 || dataViewModel.updateNextMorning() {
                    await dataViewModel.updateModel(context: viewContext)
                    dataViewModel.userDefaults.set(lastUpdateDate, forKey: "lastUpdateDateLagged")
                    dataViewModel.userDefaults.set(Date(), forKey: "lastUpdateDate")
                    didLoad = true
                }
                didLoad = true
            } else {
                await dataViewModel.updateModel(context: viewContext)
                dataViewModel.userDefaults.set(Date(), forKey: "lastUpdateDate")
                didLoad = true
            }
        }
    }
}

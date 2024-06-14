
import SwiftUI

struct FilterView: View {
    @EnvironmentObject private var fileViewModel: FileViewModel
    
    var body: some View {
        //swiftlint:disable closure_body_length
        NavigationView {
            ScrollView {
                VStack {
                    StateFilterView(showClosed: false).environmentObject(fileViewModel)
                    CountryFilterView().environmentObject(fileViewModel)
                    
                    VStack {
                        Button(action: {
                            fileViewModel.showFilter = false
                        }) {
                            Text("Filter anwenden")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding(.vertical)
                                .padding(.horizontal, 50)
                                .background(Color("Blue01"))
                                .clipShape(Capsule())
                        }
                        
                        Button(action: {
                            fileViewModel.showFilter = false
                            fileViewModel.filterByCurrentState = false
                            fileViewModel.filterByCountry = false
                        }) {
                            Text("Reset")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding(.vertical)
                                .padding(.horizontal, 50)
                                .background(.gray)
                                .clipShape(Capsule())
                        }
                    }.padding(40)
                    Spacer()
                }
            }.toolbar {
                ToolbarItem(placement: .principal) {
                }
            }
            .navigationBarItems(
                leading: HStack {
                    Text("  Filter")
                        .font(.title)
                        .accessibilityAddTraits(.isHeader)
                        .foregroundColor(Color("HighlightText"))
                })
        }
    }
}


struct CheckboxTextStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Label {
                configuration.label
            } icon: {
            }
        }
        .background(RoundedRectangle(cornerRadius: 8)
            .stroke(.primary, lineWidth: 1)
            .foregroundColor(configuration.isOn ? .blue : Color(UIColor.systemBackground))
            .shadow(color: Color.primary.opacity(0.25), radius: 6, x: 6, y: 6)
        )
        .padding()
        .buttonStyle(PlainButtonStyle())
    }
}


struct CheckToggleStyle2: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Label {
                configuration.label
            } icon: {
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(configuration.isOn ? .accentColor : .secondary)
                    .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
                    .imageScale(.large)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

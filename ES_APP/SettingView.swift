
import SwiftUI

struct SettingView: View {
    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var dataViewModel: DataViewModel
    @State var alertIsPresented = false
    //swiftlint:disable closure_body_length
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Impressum").foregroundColor(.gray)
                    Divider()
                    Text("Sprache").foregroundColor(.gray)
                    Divider()
                    Text("Benachrichtigungen").foregroundColor(.gray)
                    Divider()
                    Link("Icons by Icons8: https://icons8.com", destination: URL(string: "https://icons8.com")!)
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(Color("BoxBackground"))
                .cornerRadius(10)
                .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
                Spacer()
                VStack {
                    Button(action: { self.alertIsPresented = true }) {
                        Text("Ausloggen")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .padding(.horizontal, 50)
                            .background(Color("Blue01"))
                            .clipShape(Capsule())
                    }
                    .alert(isPresented: $alertIsPresented, content: {
                        Alert(title: Text("Sind Sie sicher?"),
                              message: Text(""),
                              primaryButton: .default( Text("Ausloggen").foregroundColor(.red),
                                                       action: {
                            let viewContext = PersistenceController.shared.container.viewContext
                            dataViewModel.removeAllFiles(context: viewContext)
                            dataViewModel.removeAllDeadlines(context: viewContext)
                            dataViewModel.removeAllFileFamilies(context: viewContext)
                            dataViewModel.userDefaults.set(nil, forKey: "lastUpdateDate")
                            authentication.updateValidation(success: false)
                        }),
                              secondaryButton: .cancel(Text("Abbrechen")))
                    })
                    .padding(25)
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(alignment: .center) {
                            Image("IP_Port_Logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100, alignment: .center)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                            Text("My IP Port").foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }
            .navigationBarItems(
                leading: HStack {
                    Text(" Einstellungen")
                        .font(.title)
                        .accessibilityAddTraits(.isHeader)
                        .foregroundColor(Color("HighlightText"))
                })
        }
        .padding(.horizontal, 12)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
            SettingView()
                .preferredColorScheme(colorScheme)
        }
    }
}

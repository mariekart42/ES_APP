
import Foundation
import SwiftUI

struct LockedView: View {
    @EnvironmentObject var lockedViewModel: LockedViewModel
    @EnvironmentObject var authentication: Authentication
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image("IP_Port_Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200, alignment: .center)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                Spacer()
            }
            HStack {
                Spacer()
                Text("My IP Port").foregroundColor(.gray)
                Spacer()
            }
            if authentication.biometricType() != .none {
                Button {
                    authentication.requestBiometricUnlockNoCredentials {
                        (result:Result<Credentials, Authentication.AuthenticationError>) in
                        switch result {
                        case .success:
                            authentication.updateUnlockStatus(success: true)
                        case .failure(let error):
                            lockedViewModel.error = error
                        }
                    }
                } label: {
                    Image(systemName: authentication.biometricType() == .face ? "faceid" : "touchid")
                        .resizable()
                        .frame(width: 50, height: 50)
                }.padding(50)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .alert(item: $lockedViewModel.error) { error in
                            return Alert(title: Text("Login fehlgeschlagen"), message: Text(error.localizedDescription))
                }
            }
            Spacer()
        }.onAppear {
            if authentication.biometricType() != .none {
                authentication.requestBiometricUnlockNoCredentials {
                    (result:Result<Credentials, Authentication.AuthenticationError>) in
                    switch result {
                    case .success:
                        authentication.updateUnlockStatus(success: true)
                    case .failure(let error):
                        lockedViewModel.error = error
                    }
                }
            }
        }
    }
}

struct LockedView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
            LockedView()
                .preferredColorScheme(colorScheme)
        }
    }
}

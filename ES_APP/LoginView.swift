
import SwiftUI
import Charts

struct LoginView: View {
    @StateObject var loginViewModel = LoginViewModel()
    
    @EnvironmentObject var authentication: Authentication
    @State var username: String = ""
    @State var password: String = ""
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        // swiftlint:disable closure_body_length
        ZStack {
            Color(red: 0.0, green: 0.19, blue: 0.27, opacity: 1.0)
                .ignoresSafeArea()
            Circle()
                .scale(1.7)
                .foregroundColor(.white.opacity(0.15))
            Circle()
                .scale(1.35)
                .foregroundColor(Color("BoxBackground"))
            VStack(spacing: 15) {
                Text("My IP Port")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)
                    .padding(20)
                VStack {
                    HStack(spacing: 20) {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.primary)
                        TextField("Benutzername", text: $loginViewModel.credentials.username)
                            .keyboardType(.emailAddress)
                    }
                    .textFieldStyle(DefaultTextFieldStyle())
                    
                    
                    Divider().background(Color.white.opacity(0.5))
                }
                
                VStack {
                    HStack(spacing: 25) {
                        Image(systemName: "key.fill")
                            .foregroundColor(.primary)
                            .padding(.leading, 2.0)
                        
                        SecureField("Passwort", text: $loginViewModel.credentials.password)
                            .padding(.leading, -2.0)
                    }
                    Divider().background(Color.white.opacity(0.5))
                }
                .textFieldStyle(DefaultTextFieldStyle())
                
                VStack {
                    HStack(spacing: 18) {
                        Image(systemName: "briefcase.fill")
                            .foregroundColor(.primary)
                            .padding(.leading, -2.0)
                        
                        TextField("Firm", text: $loginViewModel.credentials.firm)
                            .padding(.leading, 1.0)
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                }
                .textFieldStyle(DefaultTextFieldStyle())
                
                if loginViewModel.showProgressView {
                    ProgressView()
                }
                Button(action: {
                    loginViewModel.login { success in
                        if success {
                            authentication.updateValidation(success: success)
                            loginViewModel.saveCredentials()
                        }
                    }
                }) {
                    Text("Einloggen")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .padding(.horizontal, 50)
                        .background(Color("HighlightText"))
                        .clipShape(Capsule())
                    /*
                     Text("Einloggen")
                     .foregroundColor(.white)
                     .frame(width: 300, height: 50)
                     .background(Color.blue)
                     .cornerRadius(10)
                     */
                }
                .disabled(loginViewModel.loginDisabled)
                .padding()
                
//                if authentication.biometricType() != .none {
//                    Button {
//                        authentication.requestBiometricUnlock {
//                            (result:Result<Credentials, Authentication.AuthenticationError>) in
//                            switch result {
//                            case .success(let credentials):
//                                loginViewModel.credentials = credentials
//                                loginViewModel.login { success in
//                                    authentication.updateValidation(success: success)
//                                }
//                            case .failure(let error):
//                                print("My error: ", error)
//                                loginViewModel.error = error
//                            }
//                        }
//                    } label: {
//                        Image(systemName: authentication.biometricType() == .face ? "faceid" : "touchid")
//                            .resizable()
//                            .frame(width: 50, height: 50)
//                    }
//                }
            }
            .padding(50)
            .autocapitalization(.none)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .disabled(loginViewModel.showProgressView)
            .alert(item: $loginViewModel.error) { error in
                if error == .credentialsNotSaved {
                    return Alert(title: Text("Einlogdaten nicht gespeichert. Soll dies beim nächsten Login geschehen?"),
                                 message: Text(error.localizedDescription),
                                 primaryButton: .default(Text("OK"), action: {
                        loginViewModel.storeCredentialsNext = true
                    }),
                                 secondaryButton: .cancel())
                } else {
                    
                    return Alert(title: Text("Login fehlgeschlagen"), message: Text(error.localizedDescription))
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(Authentication())
            .preferredColorScheme(.light)
        LoginView()
            .environmentObject(Authentication())
            .preferredColorScheme(.dark)
    }
}

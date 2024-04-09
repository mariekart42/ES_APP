import Foundation
import UIKit
import SwiftUI
import MessageUI

//typealias MailViewCallback = ((Result<MFMailComposeResult, Error>) -> Void)?

struct MailView: UIViewControllerRepresentable {
  @Environment(\.presentationMode) var presentation
    var subject: String
    var mail: String

  class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
    @Binding var presentation: PresentationMode
      var subject: String
      var mail: String

    init(presentation: Binding<PresentationMode>, subject: String, mail: String) {
      _presentation = presentation
      self.subject = subject
      self.mail = mail
    }

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
  }

  func makeCoordinator() -> Coordinator {
      Coordinator(presentation: presentation, subject: subject, mail: mail)
  }

  func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
      let cvc = MFMailComposeViewController()
      cvc.mailComposeDelegate = context.coordinator
      cvc.setSubject(subject)
      cvc.setToRecipients([mail])
      cvc.accessibilityElementDidLoseFocus()
      return cvc
  }

  func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                              context: UIViewControllerRepresentableContext<MailView>) {
  }

  static var canSendMail: Bool {
      let emailUrl = URL(string: "mailto:mail@eisenfuhr.com?subject=----")!
      if MFMailComposeViewController.canSendMail() {
          return  true
      } else if UIApplication.shared.canOpenURL(emailUrl) {
          return true
      } else {
          return false
      }
  }
    
    static var canMFController: Bool {
    MFMailComposeViewController.canSendMail()
    }
}

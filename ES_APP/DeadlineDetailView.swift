
import SwiftUI

struct DeadlineDetailView: View {
    var deadlineId: String
    @EnvironmentObject var deadlineViewModel: DeadlineViewModel
    
    var body: some View {
        let deadline = deadlineViewModel.getDeadline(deadlineViewModel.deadlines, id: deadlineId)
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                DeadlineViewGeneral(deadline: deadline).environmentObject(deadlineViewModel)
                DeadlineViewMiddle(deadline: deadline, deadlineId: deadlineId).environmentObject(deadlineViewModel)
                DeadlineViewOtherDates(deadline: deadline).environmentObject(deadlineViewModel)
            }
            .padding(.horizontal, 12)
        }.navigationBarTitle(deadline.esSymbol)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button {
                if MailView.canMFController {
                    deadlineViewModel.showMailView.toggle()
                } else {
                    let email = "mail@eisenfuhr.com"
                    var id = deadline.esSymbol
                    var title = ""
                    title = deadline.type.replacingOccurrences(of: " ", with: "%20")
                    id = id.replacingOccurrences(of: " ", with: "%20")
                    if let url = URL(string: "mailto:\(email)?subject=\(title)--\(id)--") {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    }
                }
            }label: { Image(systemName: "envelope")
                    .disabled(!MailView.canSendMail)
                    .sheet(isPresented: $deadlineViewModel.showMailView, content: { MailView(subject: "\(deadline.occasion)--\(deadline.esSymbol)--", mail: "mail@eisenfuhr.com") })
            }
            )
    }
    
    init(_ deadlineId: String) {
        self.deadlineId = deadlineId
    }
}

struct DeadlineViewGeneral: View {
    @EnvironmentObject var deadlineViewModel: DeadlineViewModel
    var deadline: Deadline
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Spacer()
                Text("\(deadline.occasion)").font(Font.system(size: 16)).fontWeight(.bold).padding(.vertical, 5).multilineTextAlignment(.center)
                Spacer()
            }
            Text("\(deadline.occasionText)").padding(.bottom, 5)
        }.padding(15)
            .background(Color("BoxBackground"))
            .cornerRadius(10)
            .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
            .padding(.top, 20)
            .frame(maxWidth: .infinity)
        
        Spacer().frame(height: 20)
        Text("   Fristdaten")
            .foregroundColor(.secondary)
            .textCase(.uppercase)
            .font(.footnote)
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Fristtyp:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("\(deadline.type )")
            }
            Divider()
            VStack(alignment: .leading) {
                Text("Fristende:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                if deadline.deadlineDate.timeIntervalSinceReferenceDate != 0 {
                    Text("\(deadlineViewModel.getDate(date: deadline.deadlineDate))")
                } else {
                    Text("k.A.")
                }
            }
        }.padding(15)
            .background(Color("BoxBackground"))
            .cornerRadius(10)
            .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
    }
}

struct DeadlineViewMiddle: View {
    @EnvironmentObject var deadlineViewModel: DeadlineViewModel
    @StateObject var textViewModel = TextViewModel()
    @State var text: String = ""
    var deadline: Deadline
    var deadlineId: String
    
    var body: some View {
        Spacer().frame(height: 20)
        Text("   Stichwort")
            .foregroundColor(.secondary)
            .textCase(.uppercase)
            .font(.footnote)
        VStack(alignment: .leading) {
            HStack {
            Text(deadline.title)
                Spacer()
            }
        }
        .padding(15)
        .background(Color("BoxBackground"))
        .cornerRadius(10)
        .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
        
        Spacer().frame(height: 20)
        Text("   Notiz")
            .foregroundColor(.secondary)
            .textCase(.uppercase)
            .font(.footnote)
        VStack(alignment: .leading) {
            TextField("Notizfeld", text: $text, onCommit: { textViewModel.addNote(deadlineId, text) })
                .onChange(of: text) { _ in
                    textViewModel.addNote(deadlineId, text)
                }
                .submitLabel(.done)
                .padding(.vertical, 5)
        }.padding(15)
            .background(Color("BoxBackground"))
            .cornerRadius(10)
            .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
    }
}

struct DeadlineViewOtherDates: View {
    @EnvironmentObject var deadlineViewModel: DeadlineViewModel
    var deadline: Deadline
    
    var body: some View {
        Spacer().frame(height: 20)
        Text("   Weitere Daten")
            .foregroundColor(.secondary)
            .textCase(.uppercase)
            .font(.footnote)
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Anlegungsdatum:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                if deadline.creationDate!.timeIntervalSinceReferenceDate != 0 {
                    Text("\(deadlineViewModel.getDate(date: deadline.creationDate!))")
                } else {
                    Text("k.A.")
                }
            }
            Divider()
            VStack(alignment: .leading) {
                Text("Änderungsdatum:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                if deadline.changeDate!.timeIntervalSinceReferenceDate != 0 {
                    Text("\(deadlineViewModel.getDate(date: deadline.changeDate!))")
                } else {
                    Text("k.A.")
                }
            }
        }.frame(maxWidth: .infinity)
            .padding(15)
            .background(Color("BoxBackground"))
            .cornerRadius(10)
            .shadow(color: Color("Shadow").opacity(0.7), radius: 6, x: 0, y: 3)
    }
}

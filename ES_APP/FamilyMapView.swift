//
//  FamilyMapView.swift
//  My IP Port
//
//  Created by Julian Heiß on 31.05.22.
//

import SwiftUI
import JavaScriptCore
import WebKit

struct FamilyMapView: View {
    @State var scale: CGFloat = 1.0
    @EnvironmentObject var fileViewModel: FileViewModel
    var familMapViewModel: FamilyMapViewModel
    var family: FileFamily
    @State var javaScript: String

    var body: some View {
        //swiftlint:disable closure_body_length
        ZStack {
            GeometryReader { geo in
                ScrollView([.horizontal, .vertical]) {
                    Spacer()
                    WebView(text: $javaScript)
                        .frame(minWidth: 0, maxWidth: geo.size.width, minHeight: 0, maxHeight: geo.size.height)
                        .scaleEffect(self.scale)
                        .frame(width: geo.size.width * self.scale, height: geo.size.height * self.scale)
                }
            }
            VStack {
                Spacer()
                HStack {
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading) {
                            HStack {
                                Circle()
                                    .strokeBorder(.white, lineWidth: 1)
                                    .background(
                                        Circle()
                                            .fill(Color(hex: familMapViewModel.colourSetHex[0])!)
                                    )
                                    .frame(width: 15, height: 15)
                                    
                                Text(" 0 - Erloschen ")
                                    .font(.system(size: 12))
                                    .fontWeight(.medium)
                            }
                            HStack {
                                Circle()
                                    .strokeBorder(.white, lineWidth: 1)
                                    .background(
                                        Circle()
                                            .fill(Color(hex: familMapViewModel.colourSetHex[2])!)
                                    )
                                    .frame(width: 15, height: 15)
                                
                                Text(" 2 - Angemeldet ")
                                    .font(.system(size: 12))
                                    .fontWeight(.medium)
                            }
                        }
                        VStack(alignment: .leading) {
                            HStack {
                                Circle()
                                    .strokeBorder(.white, lineWidth: 1)
                                    .background(
                                        Circle()
                                            .fill(Color(hex: familMapViewModel.colourSetHex[1])!)
                                    )
                                    .frame(width: 15, height: 15)
                              
                                Text(" 1 - Akte angelegt ")
                                    .font(.system(size: 12))
                                    .fontWeight(.medium)
                            }
                            HStack {
                                Circle()
                                    .strokeBorder(.white, lineWidth: 1)
                                    .background(
                                        Circle()
                                            .fill(Color(hex: familMapViewModel.colourSetHex[3])!)
                                    )
                                    .frame(width: 15, height: 15)
                                Text(" 3 - Erteilt / Eingetragen ")
                                    .font(.system(size: 12))
                                    .fontWeight(.medium)
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    init(_ familyF: FileFamily, mode: String) {
        family = familyF
        familMapViewModel = FamilyMapViewModel(fFamily: family, colorScheme: mode)
        javaScript = familMapViewModel.getJavaScriptString()
    }
}

struct WebView: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(text, baseURL: nil)
    }
}

struct FamilyMapView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
            FamilyMapView(FileFamily(), mode: "")
                .preferredColorScheme(colorScheme)
                .environmentObject(FileViewModel())
        }
    }
}

//
//  PhoneAuthView.swift
//  HUGPETGITHUB
//
//  Created by Ahad Obaid Albaqami on 29/03/1444 AH.
//

import SwiftUI

struct PhoneAuthView: View {
    @State var isShowingHomeView: Bool = false
    @State var isShowingVerfiyView: Bool = false
    @State var showLoading : Bool = false
    @State var isLoading : Bool = false
    @State private var progress : Double = 0

    @State var fName: String = ""
    @State var phoneNumber: String = ""
    @State var smsCode: String = ""
    
    @AppStorage("Onboarding") var Onboarding: Bool = true
    
    @Environment(\.colorScheme) var colorScheme
    @Environment (\.openURL) var openURL

    @EnvironmentObject var authManager : AuthMangerViewModel

    var body: some View {
        NavigationView{
            
            VStack(spacing: 32){
         
                Text("Wolcome To HUGPet App")
                    .font(.system(size: 24, weight: .bold, design: .default))
                VStack(alignment: .leading){
                    
                    HStack{
                        Text("Enter Your Name")
                            .font(.system(size: 12, weight: .bold, design: .default))
                        Spacer()
                        // .frame(width: 230)
                    }.padding(.horizontal , 5)
                    
                    HStack{
                        TextField("Sara" , text: $fName)
                            .submitLabel(.next)
                          //  .padding()
                        
                    } .padding(.horizontal , 5)
                    .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.gray)
//                        .background(colorScheme == .dark ? Color(#colorLiteral(red: 0.1098036841, green: 0.1098041013, blue: 0.1183908954, alpha: 1)) : Color.backgroundGray)
                        .cornerRadius(16)
//                        .padding(.horizontal , 8)
                }
                // Divider()
                VStack(alignment: .leading){
                    
                    HStack{
                        Text("Enter Your Phone Number")
                            .font(.system(size: 12, weight: .bold, design: .default))
                        Spacer()
                        // .frame(width: 200)
                    }.padding(.horizontal , 5)
                    HStack{
                        Text("🇸🇦 +966")
                        TextField("54.....", text: $phoneNumber)
                            .submitLabel(.next)
                            .keyboardType(.phonePad)
                        
                        
                    } .padding(.horizontal , 5)
                    .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.gray)
//                        .background(colorScheme == .dark ? Color(#colorLiteral(red: 0.1098036841, green: 0.1098041013, blue: 0.1183908954, alpha: 1)) : Color.backgroundGray)
                        .cornerRadius(16)
                       // .padding(.horizontal , 8)
                    
                }
                
                //.padding()
                VStack{
                    
                    Button {
                        openURL(URL(string: "https://aseel3liq.wixsite.com/my-site/terms-and-conditions")!)
                    } label: {
                        Text("By joining, \(Text("you agree to our Terms of Service and Privacy Policy").foregroundColor(.blue))")
                            .foregroundColor(colorScheme == .dark ? .white : .black )
                            .font(.system(size: 10, weight: .regular, design: .default))
                    }
                }
                Button(action: {
                    showLoading.toggle()
                    DispatchQueue.main.async {
                        
                        authManager.createUserWithPhoneNumber(phoneNumber: phoneNumber, fName: fName) { isSuccess in
                            print("DEBUG: phone \(isSuccess)")
                            
                            showLoading.toggle()
                            isShowingVerfiyView = true
                            //                          isShowingVerfiyView.toggle()
                        }
                    }
                    
                }, label: {
                    
                    Text("Send Verification")
                        .font(.system(size: 17, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    
                })  .disabled(phoneNumber.isEmpty)
                
            }.padding(.horizontal , 10)
        }.overlay(
            ZStack{
                Color.black.ignoresSafeArea()
                    .opacity(0.5)
            ProgressView("OTP Will Sent")
               // .font(.subheadline)
                .progressViewStyle(CircularProgressViewStyle(tint: .indigo))
                //.scaleEffect(1.5)
            } .opacity(showLoading ? 0.5 : 0)
        )
        .fullScreenCover(isPresented: $isShowingVerfiyView , onDismiss: dismissLogin) {
            VerfiyCode(phoneNumber: $phoneNumber, smsCode: $smsCode, fName: $fName)
       
        }
        .fullScreenCover(isPresented: $isShowingHomeView) {
//           TabBarViews()
       }
    }
    func dismissLogin(){
       isShowingHomeView = true
    }
}

struct PhoneAuthView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneAuthView()
            .environmentObject(AuthMangerViewModel())

    }
}

struct VerfiyCode: View{
    
    @Binding var phoneNumber: String
    @Binding var smsCode: String
    @Binding var fName: String
    @State var showLoading : Bool = false
    @EnvironmentObject var authManager : AuthMangerViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    var body: some View{
        NavigationView{
            VStack(spacing: 32){
                
                Text("Code Verification\("\n") \(Text("The code has been sent to 0\(phoneNumber)")                         .font(.system(size: 14, weight: .regular, design: .default)))")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .multilineTextAlignment(.center)
                HStack{
                TextField("Enter OTP Code", text: $smsCode)
                    .keyboardType(.phonePad)
                }.padding(.horizontal ,8)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.gray)
                    .cornerRadius(16)
                
                Button(action: {
                    showLoading.toggle()
                    DispatchQueue.main.async {
                        authManager.verifySMSCode(verificationCode: smsCode, phoneNumber: phoneNumber, name: fName) { isSuccess in
                            print("DEBUG: in code \(isSuccess)")
                            showLoading.toggle()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }, label: {
                    Text("Login")
                        .font(.system(size: 17, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    
                })
                .disabled(smsCode.isEmpty)
                
            }.padding()
            
                .navigationTitle("Verification Code")
                .navigationBarTitleDisplayMode(.inline)
        }.overlay(
            ZStack{
                Color.black.ignoresSafeArea()
                    .opacity(0.5)
            ProgressView("Validation Checking")
                .progressViewStyle(CircularProgressViewStyle(tint: .indigo))
              //  .scaleEffect(1.5)
            } .opacity(showLoading ? 0.5 : 0)
        )
        
        
    }
}

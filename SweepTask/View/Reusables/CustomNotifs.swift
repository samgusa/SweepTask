//
//  CustomNotifs.swift
//  SweepTask
//
//  Created by Sam Greenhill on 7/24/24.
//

import SwiftUI

struct CustomNotifs: View {
    var systemIcon: String
    var iconColor: Color
    var notifText: String
    
    var body: some View {
        HStack(spacing: Constants.HStackSpacing) {
            Image(systemName: systemIcon)
                .foregroundStyle(iconColor)
                .font(.title2)
                .frame(width: Constants.imageWidth, 
                       height: Constants.imageHeight)
                .background(.thinMaterial, 
                            in: .rect(cornerRadius: Constants.imgCornerRadius))
                .padding(.leading, Constants.imagePadding)


            Text(notifText)
            Spacer()
        }
        .bold()
        .frame(maxWidth: .infinity, 
               maxHeight: Constants.frameHeight)
        .background(.thinMaterial, 
                    in: .rect(cornerRadius: Constants.viewCornerRadius))
    }

    private enum Constants {
        static let frameHeight: CGFloat = 70
        static let HStackSpacing: CGFloat = 15
        static let imageHeight: CGFloat = 50
        static let imageWidth: CGFloat = 55
        static let imagePadding: CGFloat = 10
        static let imgCornerRadius: CGFloat = 10
        static let viewCornerRadius: CGFloat = 20
    }
}

#Preview {
    CustomNotifs(
        systemIcon: "star.fill",
        iconColor: .green,
        notifText: "You are near your device")
}

//
//  Color.swift
//  WorkoutsUI
//
//  Created by Robert Dresler on 06/04/2020.
//  Copyright © 2020 Robert Dresler. All rights reserved.
//

import UIKit

public enum Color {

    public static let globalTint = resolveColor(light: blueRegular, dark: blueRegular)
    public static let background = resolveColor(light: whiteRegular, dark: black)
    public static let cellBackground = resolveColor(light: whiteRegular, dark: blackRegular)
    public static let cellHighlightedBackground = resolveColor(light: whiteRegular.darker, dark: blackRegular.lighter)
    public static let realmWorkoutCellBackground = resolveColor(light: greenLight, dark: greenDark)
    public static let firebaseWorkoutCellBackground = resolveColor(light: blueLight, dark: blueDark)
    public static let realmWorkoutCellHighlightedBackground = resolveColor(
        light: greenLight.darker, dark: greenDark.lighter
    )
    public static let firebaseWorkoutCellHighlightedBackground = resolveColor(
        light: blueLight.darker, dark: blueDark.lighter
    )
    public static let standardText = resolveColor(light: black, dark: whiteRegular)
    public static let shadow = resolveColor(light: grayDarker, dark: grayLight)
    public static let placeSelectorHighlight = UIColor.systemYellow
    public static let clear = UIColor.clear

    private static let whiteRegular = UIColor(hex: "#FFFFFF")

    private static let black = UIColor(hex: "#000000")
    private static let blackRegular = UIColor(hex: "#2C2C2C")

    private static let grayDarker = UIColor(hex: "#505050")
    private static let grayLight = UIColor(hex: "#DCDCDC")

    private static let greenLight = UIColor(hex: "#D4EFDF")
    private static let greenDark = UIColor(hex: "#297A3F")

    private static let blueLight = UIColor(hex: "#A4E2FB")
    private static let blueRegular = UIColor(hex: "#1C80FF")
    private static let blueDark = UIColor(hex: "#1F7A9F")

    // MARK: Resolving

    private static func resolveColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? dark : light
            }
        } else {
            return light
        }
    }

}

extension UIColor {
    convenience init(hex hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let alpha, red, green, blue: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: CGFloat(alpha) / 255
        )
    }

    public var hex: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let rInt = Int(red * 255) << 24
        let gInt = Int(green * 255) << 16
        let bInt = Int(blue * 255) << 8
        let aInt = Int(alpha * 255)

        let rgba = rInt | gInt | bInt | aInt

        return String(format: "#%08x", rgba)
    }

    public var darker: UIColor {

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else { return UIColor() }
        return UIColor(red: max(red - 0.2, 0.0), green: max(green - 0.2, 0.0), blue: max(blue - 0.2, 0.0), alpha: alpha)
    }

    public var lighter: UIColor {

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else { return UIColor() }
        return UIColor(red: min(red + 0.2, 1.0), green: min(green + 0.2, 1.0), blue: min(blue + 0.2, 1.0), alpha: alpha)
    }
}

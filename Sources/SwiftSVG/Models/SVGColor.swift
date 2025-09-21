import SwiftUI
import Foundation

struct SVGColor {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
    
    init?(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
        // Safe initialization - return nil if values are invalid
        guard red >= 0 && red <= 1,
              green >= 0 && green <= 1,
              blue >= 0 && blue <= 1,
              alpha >= 0 && alpha <= 1 else {
            return nil
        }
        
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    init?(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }
        
        guard hexString.count == 6 || hexString.count == 8 else { return nil }
        
        var rgbValue: UInt64 = 0
        guard Scanner(string: hexString).scanHexInt64(&rgbValue) else { return nil }
        
        if hexString.count == 6 {
            self.red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
            self.green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
            self.blue = Double(rgbValue & 0x0000FF) / 255.0
            self.alpha = 1.0
        } else {
            self.red = Double((rgbValue & 0xFF000000) >> 24) / 255.0
            self.green = Double((rgbValue & 0x00FF0000) >> 16) / 255.0
            self.blue = Double((rgbValue & 0x0000FF00) >> 8) / 255.0
            self.alpha = Double(rgbValue & 0x000000FF) / 255.0
        }
    }
    
    var color: Color {
        Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}

extension SVGColor {
    static let black = SVGColor(red: 0, green: 0, blue: 0, alpha: 1)!
    static let white = SVGColor(red: 1, green: 1, blue: 1, alpha: 1)!
    static let clear = SVGColor(red: 0, green: 0, blue: 0, alpha: 0)!
}
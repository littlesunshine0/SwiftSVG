import SwiftUI
import Foundation
import AppKit
import QuartzCore

class SVGRenderer {
    static func render(svgContent: String, size: CGSize = CGSize(width: 200, height: 200)) -> NSImage? {
        // Guard against empty or invalid data to prevent parser errors
        guard !svgContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("SVGRenderer: Cannot render empty SVG content")
            return nil
        }
        
        // Additional validation for basic SVG structure
        guard svgContent.contains("<svg") || svgContent.contains("<SVG") else {
            print("SVGRenderer: Content does not appear to be valid SVG")
            return nil
        }
        
        // Create a basic renderer for SVG content
        guard let data = svgContent.data(using: .utf8) else {
            print("SVGRenderer: Failed to convert SVG content to data")
            return nil
        }
        
        let parser = SVGParser()
        guard let parsedContent = parser.parse(data: data) else {
            print("SVGRenderer: Failed to parse SVG data")
            return nil
        }
        
        // Create a simple rendered image
        return createRenderedImage(from: parsedContent, size: size)
    }
    
    private static func createRenderedImage(from svgContent: String, size: CGSize) -> NSImage? {
        let image = NSImage(size: size)
        
        image.lockFocus()
        defer { image.unlockFocus() }
        
        // Simple rendering - draw a placeholder rectangle with SVG icon
        let rect = NSRect(origin: .zero, size: size)
        
        // Background
        NSColor.systemBackground.set()
        rect.fill()
        
        // Border
        NSColor.systemGray.set()
        let borderRect = rect.insetBy(dx: 1, dy: 1)
        borderRect.frame(withWidth: 2)
        
        // SVG text indicator
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: min(size.width, size.height) * 0.1),
            .foregroundColor: NSColor.systemGray
        ]
        
        let svgText = "SVG"
        let textSize = svgText.size(withAttributes: attributes)
        let textRect = NSRect(
            x: (size.width - textSize.width) / 2,
            y: (size.height - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height
        )
        
        svgText.draw(in: textRect, withAttributes: attributes)
        
        return image
    }
    
    static func generateThumbnail(for svgItem: SVGItem, size: CGSize = CGSize(width: 64, height: 64)) -> NSImage? {
        return render(svgContent: svgItem.content, size: size)
    }
}
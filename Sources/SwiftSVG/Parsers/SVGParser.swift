import Foundation
import SwiftUI

struct GradientStop {
    let offset: Double
    let color: SVGColor
    
    init?(offset: Double, colorString: String) {
        guard offset >= 0 && offset <= 1 else { return nil }
        
        // Safely unwrap the SVGColor initializer for gradient stops
        guard let color = SVGColor(hex: colorString) else {
            // Fallback to a default color if parsing fails
            self.color = SVGColor.black
            self.offset = offset
            return
        }
        
        self.color = color
        self.offset = offset
    }
}

class SVGParser: NSObject, XMLParserDelegate {
    private var svgContent: String = ""
    private var currentElement: String = ""
    private var gradientStops: [GradientStop] = []
    private var isParsingValid = false
    
    func parse(data: Data) -> String? {
        // Guard against empty or invalid data to prevent NSXMLParserErrorDomain error 1
        guard !data.isEmpty else {
            print("SVGParser: Cannot parse empty data")
            return nil
        }
        
        // Validate that the data contains valid XML content
        guard let contentString = String(data: data, encoding: .utf8),
              !contentString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("SVGParser: Cannot parse invalid or empty string data")
            return nil
        }
        
        let parser = XMLParser(data: data)
        parser.delegate = self
        
        isParsingValid = parser.parse()
        
        return isParsingValid ? contentString : nil
    }
    
    // MARK: - XMLParserDelegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if elementName == "stop" {
            // Safely handle gradient stops to prevent crashes
            let offsetString = attributeDict["offset"] ?? "0"
            let colorString = attributeDict["stop-color"] ?? "#000000"
            
            let offset = Double(offsetString.replacingOccurrences(of: "%", with: "")) ?? 0.0
            let normalizedOffset = offsetString.contains("%") ? offset / 100.0 : offset
            
            if let gradientStop = GradientStop(offset: normalizedOffset, colorString: colorString) {
                gradientStops.append(gradientStop)
            }
            // If gradient stop creation fails, we simply don't add it - no crash
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        // Handle character data if needed
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("SVGParser: Parse error occurred: \(parseError.localizedDescription)")
        isParsingValid = false
    }
}
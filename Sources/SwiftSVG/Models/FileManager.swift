import Foundation
import UniformTypeIdentifiers
import AppKit

class SVGFileManager {
    static func importSVGFiles() -> [SVGItem] {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = true
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowedContentTypes = [UTType.svg, UTType.xml]
        
        guard openPanel.runModal() == .OK else { return [] }
        
        return openPanel.urls.compactMap { url in
            loadSVGFile(from: url)
        }
    }
    
    static func scanFolder() -> [SVGItem] {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        
        guard openPanel.runModal() == .OK,
              let folderURL = openPanel.urls.first else { return [] }
        
        return scanFolderForSVGs(at: folderURL)
    }
    
    private static func scanFolderForSVGs(at url: URL) -> [SVGItem] {
        var svgItems: [SVGItem] = []
        
        guard let enumerator = Foundation.FileManager.default.enumerator(
            at: url,
            includingPropertiesForKeys: [.isRegularFileKey, .contentTypeKey],
            options: [.skipsHiddenFiles]
        ) else { return [] }
        
        for case let fileURL as URL in enumerator {
            do {
                let resourceValues = try fileURL.resourceValues(forKeys: [.isRegularFileKey, .contentTypeKey])
                
                guard resourceValues.isRegularFile == true else { continue }
                
                let pathExtension = fileURL.pathExtension.lowercased()
                if pathExtension == "svg" {
                    if let svgItem = loadSVGFile(from: fileURL) {
                        svgItems.append(svgItem)
                    }
                }
            } catch {
                print("Error reading file attributes: \(error)")
            }
        }
        
        return svgItems
    }
    
    private static func loadSVGFile(from url: URL) -> SVGItem? {
        do {
            // Request access to the file
            guard url.startAccessingSecurityScopedResource() else {
                print("Failed to access security scoped resource: \(url)")
                return nil
            }
            defer { url.stopAccessingSecurityScopedResource() }
            
            let content = try String(contentsOf: url, encoding: .utf8)
            
            // Validate that we have actual SVG content
            guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                  content.contains("<svg") || content.contains("<SVG") else {
                print("File does not contain valid SVG content: \(url)")
                return nil
            }
            
            return SVGItem(url: url, content: content)
        } catch {
            print("Error loading SVG file \(url): \(error)")
            return nil
        }
    }
}

// Extension to support UTType.svg if not available
extension UTType {
    static var svg: UTType {
        UTType(filenameExtension: "svg") ?? UTType.xml
    }
}
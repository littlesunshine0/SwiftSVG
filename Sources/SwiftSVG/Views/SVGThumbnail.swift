import SwiftUI
import Foundation
import AppKit

struct SVGThumbnail: View {
    let svgItem: SVGItem
    let size: CGSize
    @State private var thumbnailImage: NSImage?
    @State private var isLoading = true
    @State private var hasError = false
    
    init(svgItem: SVGItem, size: CGSize = CGSize(width: 64, height: 64)) {
        self.svgItem = svgItem
        self.size = size
    }
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(width: size.width, height: size.height)
            } else if hasError || thumbnailImage == nil {
                // Fallback error image for invalid SVGs
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(.orange)
                    .frame(width: size.width, height: size.height)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(4)
            } else if let image = thumbnailImage {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size.width, height: size.height)
                    .cornerRadius(4)
            }
        }
        .onAppear {
            generateThumbnail()
        }
    }
    
    private func generateThumbnail() {
        // Render thumbnails in the background for smooth experience
        Task.detached(priority: .background) {
            do {
                let thumbnail = await generateThumbnailSafely()
                
                await MainActor.run {
                    self.thumbnailImage = thumbnail
                    self.isLoading = false
                    self.hasError = (thumbnail == nil)
                }
            } catch {
                await MainActor.run {
                    self.hasError = true
                    self.isLoading = false
                    print("SVGThumbnail: Error generating thumbnail: \(error)")
                }
            }
        }
    }
    
    @MainActor
    private func generateThumbnailSafely() async -> NSImage? {
        // Robust checks for layer size and graphics context creation
        guard size.width > 0, size.height > 0 else {
            print("SVGThumbnail: Invalid size for thumbnail generation")
            return nil
        }
        
        guard !svgItem.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("SVGThumbnail: Empty SVG content")
            return nil
        }
        
        // Use the SVGRenderer with all its safety checks
        return SVGRenderer.generateThumbnail(for: svgItem, size: size)
    }
}

#Preview {
    let sampleSVG = """
    <svg width="100" height="100" xmlns="http://www.w3.org/2000/svg">
        <rect width="100" height="100" fill="blue"/>
    </svg>
    """
    
    let svgItem = SVGItem(
        url: URL(fileURLWithPath: "/sample.svg"),
        content: sampleSVG
    )
    
    return SVGThumbnail(svgItem: svgItem, size: CGSize(width: 100, height: 100))
}
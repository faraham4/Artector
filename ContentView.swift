//
//  ContentView.swift
//  Artector
//
//  Created by Lujain Yhia on 11/06/1445 AH.
//

//import SwiftUI
//import CoreML
//import CoreImage
//
//struct ContentView: View {
//    @State private var error: Bool = false
//    @State private var predictedImage: UIImage?
//    let labels = ["Blind Light", "Builders", "Composition","Dark sea","Fosa","Our generous land","Still life with fish ","The land of solidities","Thursday Market","Untitled (Desert series)", "Untitled 1987", "Untitled 1988"]
//    @State private var classificationLabel = ""
//    @State private var selectedPainting: Painting?
//    
//    
//    
//     var capturedImage: UIImage
//
//    let model: MyImageClassifier = {
//        do {
//            let config = MLModelConfiguration()
//            config.computeUnits = .cpuOnly
//            return try MyImageClassifier(configuration: config)
//        } catch {
//            print(error)
//            fatalError("")
//        }
//    }()
//
//    var body: some View {
//            VStack {
//                // image is here
//                Image(uiImage: capturedImage)
//                    .resizable()
//                    .frame(width: 299, height: 299)
//                    .accessibilityLabel("Captured Image")
//                    .accessibility(hint: Text("Image for identification"))
//                
//                Spacer()
//
//                Button("Identify") {
//                    classifyImage(capturedImage: capturedImage)
//                }
//                .padding()
//                .foregroundColor(Color.white)
//                .frame(width: 250)
//                .background(Color.black)
//                .cornerRadius(10)
//                .accessibilityLabel("Identify Image")
//                .accessibility(hint: Text("Tap to start image Identification"))
//
//                NavigationLink(destination: ResultPage(painting: selectedPainting, image: predictedImage)) {
//                    Text("Show Painting Info")
//                        .padding()
//                        .frame(width: 250)
//                        .foregroundColor(Color.black)
//                        .background(Color.white)
//                        .cornerRadius(10)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(Color.black, lineWidth: 2) // Apply border color and width
//                        )
//                }
//                .padding()
//                .accessibilityLabel("Show Painting Info")
//                .accessibility(hint: Text("Navigate to painting info page"))
//
//                Text(classificationLabel)
//                    .padding()
//                    .font(.body)
//                    .multilineTextAlignment(.center)
//                    .accessibilityLabel("Image Identification Result")
//                    .accessibility(hint: Text("Result of the identification"))
//            }
//            .padding()
//            .navigationBarTitle("Image Identification", displayMode: .inline)
//        
//    }
//
//    private func classifyImage(capturedImage: UIImage) {
//        do {
//             /*let image = capturedImage,*/ //UIImage(named: "Image")
//            guard let ciImage = CIImage(image: capturedImage),
//                  let pixelBuffer = capturedImage.pixelBuffer() else {
//                return
//            }
//
//            let input = MyImageClassifierInput(image: pixelBuffer)
//            let prediction = try model.prediction(input: input)
//            print("✓ Prediction done")
//
//            // Update the classificationLabel with the predicted classLabel
////            self.classificationLabel = "✔️✔️✔️"//success message
//            self.classificationLabel = " \(prediction.target)"
//
//            // Find the corresponding Painting based on the predicted label
//            if let matchedPainting = paintings[prediction.target] {
//                self.selectedPainting = matchedPainting
//                self.predictedImage = capturedImage
//            } else {
//                // Reset selectedPainting and predictedImage if no match is found
//                self.selectedPainting = nil
//                self.predictedImage = nil
//            }
//
//        } catch {
//            // Handle errors
//            self.error = true
//            print("Something went wrong!\n\(error.localizedDescription)\n\nMore Info:\n\(error)")
//
//            // Update the classificationLabel with an error message
//            self.classificationLabel = "Image Identification Unsuccessful"
//        }
//    }
//
//
//}
//
//extension UIImage {
//    func pixelBuffer() -> CVPixelBuffer? {
//        guard let ciImage = CIImage(image: self) else {
//            return nil
//        }
//
//        var pixelBuffer: CVPixelBuffer?
//        let options: [CIImageOption: Any] = [
//            .applyOrientationProperty: true,
//            .colorSpace: CGColorSpaceCreateDeviceRGB()
//        ]
//
//        let status = CVPixelBufferCreate(kCFAllocatorDefault,
//                                         Int(ciImage.extent.width),
//                                         Int(ciImage.extent.height),
//                                         kCVPixelFormatType_32ARGB,
//                                         options as CFDictionary,
//                                         &pixelBuffer)
//
//        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
//            return nil
//        }
//
//        let context = CIContext()
//        context.render(ciImage, to: buffer)
//
//        return buffer
//    }
//}
//#Preview {
//    ContentView()
//}




















import SwiftUI
import CoreML
import CoreImage

struct ContentView: View {
    @State private var error: Bool = false
    @State private var predictedImage: UIImage?
    let labels = ["Blind Light", "Builders", "Composition","Dark sea","Fosa","Our generous land","Still life with fish ","The land of solidities","Thursday Market","Untitled (Desert series)", "Untitled 1987", "Untitled 1988"]
    @State private var classificationLabel = ""
    @State private var selectedPainting: Painting?
    @State private var navigateToResultPage = false
    
    var capturedImage: UIImage

    let model: MyImageClassifier = {
        do {
            let config = MLModelConfiguration()
            config.computeUnits = .cpuOnly
            return try MyImageClassifier(configuration: config)
        } catch {
            print(error)
            fatalError("Failed to load model")
        }
    }()

    var body: some View {
        VStack {
            Image(uiImage: capturedImage)
                .resizable()


            Spacer()

            Button("Identify") {
                classifyImage(capturedImage: capturedImage)
            }
            .padding()
            .foregroundColor(Color.white)
            .frame(width: 250)
            .background(Color.black)
            .cornerRadius(10)

            NavigationLink(destination: ResultPage(painting: selectedPainting, image: predictedImage), isActive: $navigateToResultPage) {
                Text("Show Painting Info")
                    .padding()
                    .frame(width: 250)
                    .foregroundColor(Color.black)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
            }
            .padding()

            Text(classificationLabel)
                .padding()
                .font(.body)
                .multilineTextAlignment(.center)
        }
        .padding()
        .navigationBarTitle("Image Identification", displayMode: .inline)
    }

    private func classifyImage(capturedImage: UIImage) {
        do {
            guard let pixelBuffer = capturedImage.pixelBuffer() else {
                return
            }

            let input = MyImageClassifierInput(image: pixelBuffer)
            let prediction = try model.prediction(input: input)

            let confidence = prediction.targetProbability[prediction.target] ?? 0
            self.classificationLabel = "Match: \(Int(confidence * 100))%"

            if confidence >= 0.85 {
                if let matchedPainting = paintings[prediction.target] {
                    self.selectedPainting = matchedPainting
                    self.predictedImage = capturedImage
                    self.navigateToResultPage = true
                } else {
                    self.selectedPainting = nil
                    self.predictedImage = nil
                }
            }
        } catch {
            self.error = true
            self.classificationLabel = "Image Identification Unsuccessful"
        }
    }
}

extension UIImage {
    func pixelBuffer() -> CVPixelBuffer? {
        guard let ciImage = CIImage(image: self) else {
            return nil
        }

        var pixelBuffer: CVPixelBuffer?
        let options: [CIImageOption: Any] = [
            .applyOrientationProperty: true,
            .colorSpace: CGColorSpaceCreateDeviceRGB()
        ]

        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(ciImage.extent.width),
                                         Int(ciImage.extent.height),
                                         kCVPixelFormatType_32ARGB,
                                         options as CFDictionary,
                                         &pixelBuffer)

        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }

        let context = CIContext()
        context.render(ciImage, to: buffer)

        return buffer
    }
}

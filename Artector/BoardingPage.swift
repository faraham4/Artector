import SwiftUI

struct BoardingView: View {
    
    @State private var currentTab = 0
    var skipAction: () -> Void = {
                print("Skip button tapped")
              
            }
    
    var body: some View {
        NavigationView{
            VStack {
                TabView(selection: $currentTab,
                        content: {
                    
                    //page1
                    VStack {
                        VStack{
                            
                            Image("HandCapture") // Replace with your image name
                                .resizable()
                                .scaledToFit()
                                .frame(width: 240, height: 290)
                                .accessibilityLabel("Illustrative image of a hand holding a phone to capture a painting image")
                            
                        }.padding(.bottom, 60)
                        
                        
                        Text("Easy Capture")
                            .font(.title)
                            .fontWeight(.medium)
                            .accessibilityLabel("Easy Capture")
                        Text("Take a picture of the painting you want to know more about")
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24.0)
                            .accessibilityLabel("Take a picture of the painting you want to know more about")
                            
                    }.tag(0)
                    //page 2
                    VStack{
                        
                        Image("PaintingScan") // Replace with your image name
                            .resizable()
                            .scaledToFit()
                            .frame(width: 290, height: 290)
                            .padding(.bottom, 60)
                            .accessibilityLabel("Illustrative image of a painting getting scanned")
                        
                        Text("Fast Scan")
                            .font(.title)
                            .fontWeight(.semibold)
                            .accessibilityLabel("Fast Scan")
                        
                        Text("Sit back and let our AI system recognize the painting")
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24.0)
                            .accessibilityLabel("Sit back and let our AI system recognize the painting")
//                            .tag(1)
                        
                    }.tag(1)
                    // page3
                    VStack {
                        
                        Image("DescriptionImage") // Replace with your image name
                            .resizable()
                            .scaledToFit()
                            .frame(width: 151, height: 290)
                            .padding(.bottom, 60)
                            .accessibilityLabel("Illustrative image of a phone containing a painting image with imaginary text boxes")
                        
                        Text("Enjoy The Story")
                            .font(.title)
                            .fontWeight(.semibold)
                            .accessibilityLabel("Enjoy The Story")
                        
                        Text("Get a detailed description of the painting in text and sound")
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24.0)
                            .accessibilityLabel("Get a detailed description of the painting in text and sound")
                        
                    }.tag(2)
                })
                
                HStack{
                    
                    Spacer()
                    NavigationLink(destination: CameraPage(), label:{
                        Text("Skip")
                            .foregroundColor(Color("PrimaryColor"))
                            .fontWeight(.medium)
                            .font(.title3)
                            .accessibilityLabel("Skip Button")
                    })
                    
                }.padding([.bottom, .top, .trailing], 24)
                
            }
            .padding()
            .tabViewStyle(PageTabViewStyle())
            
            .onAppear {
                setupAppearance()
            }
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .automatic))
        }
    }
    
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color("PrimaryColor"))
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color("PrimaryColor")).withAlphaComponent(0.3)
    }
}


struct BoardingView_Previews: PreviewProvider {
    static var previews: some View {
        BoardingView()
    }
}



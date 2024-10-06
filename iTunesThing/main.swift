import Foundation
import iTunesLibrary

print("Hello, World!")

let library = try ITLibrary(apiVersion: "1.0", options: ITLibInitOptions.lazyLoadData)
print("iTunes Version: \(library.applicationVersion)")

while true {
    
    if let randomItem = library.allMediaItems.randomElement() {
        print("\(randomItem.persistentID) - \(randomItem.title) - \(randomItem.artist?.name ?? "Unknown Album") on \(randomItem.album.title ?? "Unknown Album" )")
        
        print("DRM Protected: \(randomItem.isDRMProtected), Is Cloud: \(randomItem.isCloud)")
        print("Press P + Return to play, Return to pick another track")
        
        let line = readLine()
        
        if line == "p" || line == "P" {
            let appleScript = """
tell application id "com.apple.Music"
    play (every track whose name is "\(randomItem.title)"\((randomItem.artist != nil) ? """
 and artist is "\(randomItem.artist?.name ?? "")"
""" : ""))
end tell
"""
            
            if let script = NSAppleScript(source: appleScript) {
                var error: NSDictionary?
                
                let result = script.executeAndReturnError(&error)
                if let error = error {
                    print("Failed to execute AppleScript!", error)
                } else {
                    print("Track (should) be playing \n")
                }
            }
        } else {
            continue
        }
    }
}

Pod::Spec.new do |s|
  s.name         = "JonAlert"
  s.version      = "1.0.0"
  s.summary      = "A simple and elegant feedback alert like Spotify's, written in Swift"
  s.description  = "JonAlert can be used to give feedbacks to the user after he/she performed some action."
  s.homepage     = "https://github.com/jonSurrey/JonAlert"
  s.screenshots  = "https://raw.githubusercontent.com/jonSurrey/JonAlert/master/alert_single_message.png", "https://raw.githubusercontent.com/jonSurrey/JonAlert/master/alert_success.png", "https://raw.githubusercontent.com/jonSurrey/JonAlert/master/alert_error.png"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author  = { "Jonathan Martins" => "jon.martinsu@gamil.com" }
  s.platform     = :ios
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/jonSurrey/JonAlert.git", :tag => "#{s.version}"}
  s.source_files  = "JonAlert/JonAlert/**/*.{swift}"
s.swift_version = "4.1" 
s.resources = "JonAlert/JonAlert/*.xcassets"
s.requires_arc = true


end

Pod::Spec.new do |s|

  s.name         = "Cadenza"
  s.version      = "0.0.1"
  s.summary      = "Provides simple accessors, templates and utility functions as category"
  s.description  = <<-DESC
                   Cadenza provides usefule categories for your project.
                   DESC

  s.homepage     = "https://github.com/goccy/Cadenza"
  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author       = { "Masaaki Goshima" => "goccy54@gmail.com" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "git@github.com:goccy/Cadenza.git", :tag => "0.0.1" }
  s.source_files = 'Cadenza/**/*.{h,m}'
  s.requires_arc = true

end

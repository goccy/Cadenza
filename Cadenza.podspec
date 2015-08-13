Pod::Spec.new do |s|

  s.name         = "Cadenza"
  s.version      = "0.2.2"
  s.summary      = "Useful categories"
  s.description  = <<-DESC
                   * can manage photo frame(edit/generating image).
                   DESC

  s.homepage     = "https://hanna.backlog.jp/projects/NH2014"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Masaaki Goshima" => "masaaki.goshima@mixi.co.jp" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "hanna@hanna.git.backlog.jp:/IOS_LIB/Cadenza.git", :tag => "0.2.2" }
  s.source_files = 'Cadenza/**/*.{h,m}'
  s.requires_arc = true

end

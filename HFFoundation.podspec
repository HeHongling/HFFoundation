# podspec
Pod::Spec.new do |s|
  s.name         = "HFFoundation"
  s.version      = "0.0.1"
  s.summary      = "The universal tools for iOS development."
  s.license      = "MIT"
  s.homepage     = "https://coding.net/u/HeHongling/p/HFFoundation"
  s.author       = { "HenryHe" => "henry725@qq.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://git.coding.net/HeHongling/HFFoundation.git", :tag => "#{s.version}" }
  s.source_files  = 'HFFoundation/HFFoundation'
  s.public_header_files = 'HFFoundation/HFFoundation/HFFoundation.h'
  s.requires_arc = true
  s.frameworks  = "UIKit", 'CoreFoundation', 'CoreGraphics'

  # Category
  s.subspec 'Category' do |ss|
  ss.source_files = 'HFFoundation/HFFoundation/Category/**/*.{h,m,c,mm}'
  end

  # View
  s.subspec 'View' do |ss|
  ss.source_files = 'HFFoundation/HFFoundation/View/**/*.{h,m,c,mm}'
  ss.dependency 'HFFoundation/Category'
  end

  # Controller
  s.subspec 'Controller' do |ss|
  ss.source_files = 'HFFoundation/HFFoundation/Controller/**/*.{h,m,c,mm}'
  end

  # Util
  s.subspec 'Util' do |ss|
  ss.source_files = 'HFFoundation/HFFoundation/Util/**/*.{h,m,c,mm}'
  end

end
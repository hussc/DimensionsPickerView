#
# Be sure to run `pod lib lint DimensionsPickerView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DimensionsPickerView'
  s.version          = '0.0.1'
  s.summary          = 'A Simple Highly Customizable Dimensions Picker ( Weight, Size, Speed, ... ) view for iOS'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A Simple Highly Customizable Dimensions Picker control for iOS,
with support for a wide range of unit selection, like:
  - Mass
  - Speed
  - Sizes ( 1, 2, 3 dimensions, or even more )
  
                       DESC

  s.homepage         = 'https://github.com/hussc/DimensionsPickerView'
  s.screenshots     = 'https://i.postimg.cc/G2JhLHCB/Simulator-Screen-Shot-My-i-Phone-SE-2019-11-08-at-07-12-34.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hussc' => 'hus.sc@aol.com' }
  s.source           = { :git => 'https://github.com/hussc/DimensionsPickerView.git', :tag => s.version.to_s }
   s.social_media_url = 'https://facebook.com/hussc'

  s.ios.deployment_target = '10.0'
  s.swift_version  = '5.0'

  s.source_files = 'DimensionsPickerView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'DimensionsPickerView' => ['DimensionsPickerView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit'
end

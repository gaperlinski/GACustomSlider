Pod::Spec.new do |s|
  s.name             = 'GACustomSlider'
  s.version          = '1.0.0'
  s.summary          = 'GACustomSlider is a custom variant of the UISlider containing two thumbs.'
  s.homepage         = 'https://github.com/gaperlinski/GACustomSlider'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Grzegorz Aperliński' => 'gaperlinski@gmail.com' }
  s.source           = { :git => 'https://github.com/gaperlinski/GACustomSlider.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'GACustomSlider/Classes/**/*'
end

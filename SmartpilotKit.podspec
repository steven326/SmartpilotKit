
Pod::Spec.new do |spec|
  spec.name         = "SmartpilotKit"
  spec.version      = "0.0.1"
  spec.summary      = "智慧港航产品通用组件库"
  spec.homepage     = "https://github.com/steven326/SmartpilotKit"
  spec.license      = "MIT"
  spec.author       = { "wangzeping" => "382995681@qq.com" }
  spec.platform     = :ios, "10.0"
  spec.source       = { :git => "https://github.com/steven326/SmartpilotKit.git", :tag => "#{spec.version}" }
  spec.source_files  = "SmartpilotKit", "Sources/Core/**"
  spec.default_subspec = "Core"

  spec.dependency 'AFNetworking'
  spec.dependency 'SDWebImage'
  spec.dependency 'MJRefresh'
  spec.dependency 'MBProgressHUD'
  spec.dependency 'Masonry'
  spec.dependency 'Toast'
  spec.dependency 'TZImagePickerController'
  spec.dependency 'lottie-ios', '<= 2.5.0'
  spec.dependency 'YBImageBrowser/Video'
  spec.dependency 'LEEAlert'
  spec.dependency 'LCActionSheet'
  spec.dependency 'YYModel'
  spec.dependency 'YYCategories'
  spec.dependency 'YYText'
  spec.dependency 'MLLabel'

  spec.subspec 'Core' do |core|
    core.source_files = 'SmartpilotKit', 'Sources/Core/**/*.{h,m}'
  end

  spec.subspec 'Moment' do |moment|
    # moment.source_files = 'SmartpilotKit', 'Sources/Moment/Module/**/*.{h,m}'
    moment.source_files = 'SmartpilotKit', 'Sources/Moment/**/*.{h,m}'
    moment.dependency 'SmartpilotKit/Core'
    # moment.dependency 'AMapLocation'
    # moment.dependency 'AMapSearch'
    # moment.dependency 'AMap2DMap'
  end

  spec.requires_arc = true

  # spec.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end

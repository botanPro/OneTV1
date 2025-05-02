# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      xcconfig_path = config.base_configuration_reference.real_path
      xcconfig = File.read(xcconfig_path)
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15'
      xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
      File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
    end
  end
end




target 'OneTV' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

   source 'https://github.com/CocoaPods/Specs.git'


pod 'PSMeter'
pod 'EFInternetIndicator'
pod "RSLoadingView"
pod 'Alamofire'
pod 'SwiftyJSON'
pod 'CRRefresh'
pod 'FSPagerView'
pod 'SDWebImage'
pod 'PureLayout'
pod 'MBRadioCheckboxButton'
pod "CollieGallery"
pod 'Cosmos'

pod 'SwiftAlertView', '~> 2.2.1'
pod 'RealmSwift'
pod 'lottie-ios'


pod 'Firebase'
pod 'Firebase/Auth'
pod 'Firebase/Analytics'
pod 'Firebase/Core'
pod 'Firebase/Messaging'

pod "EPSignature"

  pod 'RadioButton'
  pod 'Toast-Swift', '~> 5.0.1'
  
  pod 'Drops', :git => 'https://github.com/omaralbeik/Drops.git', :tag => '1.7.0'
  pod 'EmptyDataSet-Swift', '~> 5.0.0'
  pod "PullToDismissTransition"

pod 'HMSegmentedControl'
pod 'MXSegmentedPager'
pod 'AZDialogView'
pod 'Slider2'
pod "BSImagePicker", "~> 2.8"
pod 'ScrollingPageControl'

pod 'MHLoadingButton'
pod 'PhoneNumberKit', '~> 3.3'

pod 'CustomLoader'
pod 'LIHImageSlider'
pod "CollieGallery"

pod 'AlertToast'

pod 'MZTimerLabel'
pod 'AEOTPTextField'

pod 'GravitySliderFlowLayout'

pod 'MobilliumQRCodeReader'

pod "DDHTimerControl"

pod 'lottie-ios'

pod 'FCAlertView'

pod 'TagTextField'

pod 'TagsList'

pod 'DropDown'

pod 'FMPhotoPicker', '~> 1.3.0'
pod "SCPageControl"





pod 'CHIPageControl', '~> 0.1.3'
pod 'CHIPageControl/Aji'
pod 'CHIPageControl/Aleppo'
pod 'CHIPageControl/Chimayo'
pod 'CHIPageControl/Fresno'
pod 'CHIPageControl/Jalapeno'
pod 'CHIPageControl/Jaloro'
pod 'CHIPageControl/Paprika'
pod 'CHIPageControl/Puya'


pod 'SBDropDown'

end

use_frameworks!
inhibit_all_warnings!
workspace 'Workouts'
platform :ios, '13.0'

def base_rx_pods
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
end

def realm
  pod 'RealmSwift', '~> 4.4.0'
end

def rswift
  pod 'R.swift', '~> 5.1.0'
end

def snap_kit
  pod 'SnapKit', '~> 5.0.0'
end

def swiftlint
  pod 'SwiftLint', '~> 0.39.0'
end

target 'Workouts' do
  base_rx_pods
  realm
  rswift
  snap_kit
  swiftlint
  pod 'RxGesture', '~> 3'
  pod 'Toast-Swift', '~> 5.0.1'
  pod 'IQKeyboardManagerSwift', '6.5.0'
end



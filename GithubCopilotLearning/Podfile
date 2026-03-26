platform :ios, '18.0'
# ignore all warnings from all dependencies
inhibit_all_warnings!
target 'GithubCopilotLearning' do
  use_frameworks!
  # Default pods
  pod 'R.swift'
  pod 'Bagel'
  pod 'Sentry'
  pod 'SSAppUpdater'
  pod 'Kingfisher'
  pod 'Navajo-Swift'
  pod 'SwiftMessages'
  pod 'PhoneNumberKit'
  pod 'SFSafeSymbols'
  pod 'SwiftDate'
  pod 'SwiftLint'
  pod 'Connectivity'
  pod 'GithubCopilotLearningSecrets', path: './ArkanaKeys/GithubCopilotLearningSecrets'
  pod 'GithubCopilotLearningSecretsInterfaces', path: './ArkanaKeys/GithubCopilotLearningSecretsInterfaces'
end
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '18.0'
      config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
    end
  end
end
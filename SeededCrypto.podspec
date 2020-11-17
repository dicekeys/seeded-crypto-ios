
Pod::Spec.new do |s|
  s.name             = 'SeededCrypto'
  s.version          = '0.1.0'
  s.summary          = 'Seeded Cryptography Library for iOS'

  s.description      = <<-DESC
Dicekeys Seeded Cryptography Library for iOS
                       DESC

  s.homepage         = 'https://github.com/dicekeys/seeded-crypto-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'bakhtiyor' => 'bakhtiyor.k@gmail.com' }
  s.source           = { :git => 'https://github.com/dicekeys/seeded-crypto-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.3'

  s.source_files = 'SeededCrypto/Classes/**/*',
    'SeededCrypto/seeded-crypto/lib-seeded/**/*.{cpp,hpp,h}',
    'SeededCrypto/seeded-crypto/extern/libsodium/src/libsodium/**/*.{c,h}'
  s.private_header_files = 'SeededCrypto/Classes/DSCHelper.h'

  s.prepare_command = "cd SeededCrypto/seeded-crypto/extern/libsodium/; sh ./configure --disable-dependency-tracking; cd -"
  s.pod_target_xcconfig = {
    "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/SeededCrypto/seeded-crypto/extern/libsodium/src/libsodium/include/sodium\" \"$(PODS_TARGET_SRCROOT)/SeededCrypto/seeded-crypto/extern/libsodium/src/libsodium/include\" \"$(PODS_TARGET_SRCROOT)/SeededCrypto/seeded-crypto/lib-seeded\"",
    "OTHER_CFLAGS" => "-DNATIVE_LITTLE_ENDIAN=1 -DHAVE_MADVISE -DHAVE_MMAP -DHAVE_MPROTECT -DHAVE_POSIX_MEMALIGN -DHAVE_WEAK_SYMBOLS"
  }
   
  s.public_header_files = 'SeededCrypto/Classes/**/*.h'
end

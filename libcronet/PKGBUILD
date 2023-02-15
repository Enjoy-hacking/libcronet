# Maintainer: Evangelos Foutras <evangelos@foutrelis.com>

pkgname=libcronet-static
pkgver=110.0.5481.77
pkgrel=2
pkgdesc="Cronet is the networking stack of Chromium put into a library for use on mobile"
arch=('x86_64')
url="https://www.chromium.org/Home"
license=('BSD')
makedepends=('python' 'gn' 'ninja' 'clang' 'lld' 'git')
options=('!lto') # Chromium adds its own flags for ThinLTO
source=(
  https://commondatastorage.googleapis.com/chromium-browser-official/chromium-$pkgver.tar.xz
  0001-add-cronet-static.patch
)
sha256sums=(
  'e348ab2dc4311083e729d714a81e95dd9db108ff71437dde451c97ac939881ce'
  'c5f1ed22c387d5b0c15d7ba73d5f33aee20f26327249b10d69ecdc82649b790b'
)

# Google API keys (see https://www.chromium.org/developers/how-tos/api-keys)
# Note: These are for Arch Linux use ONLY. For your own distribution, please
# get your own set of keys.
#
# Starting with Chromium 89 (2021-03-02) the OAuth2 credentials have been left
# out: https://archlinux.org/news/chromium-losing-sync-support-in-early-march/
_google_api_key=AIzaSyDwr302FpOSkGRpLlUpPThNTDPbXcIn_FM

prepare() {
  cd chromium-$pkgver
  patch -Np1 -i ../0001-add-cronet-static.patch
}

build() {
  cd chromium-$pkgver

  export CC=clang
  export CXX=clang++
  export AR=ar
  export NM=nm

  local _flags=(
    'custom_toolchain="//build/toolchain/linux/unbundle:default"'
    'host_toolchain="//build/toolchain/linux/unbundle:default"'
    'clang_base_path="/usr"'
    'clang_use_chrome_plugins=false'
    'is_official_build=true' # implies is_cfi=true on x86_64
    'symbol_level=0' # sufficient for backtraces on x86(_64)
    #'chrome_pgo_phase=0' # needs newer clang to read the bundled PGO profile
    'treat_warnings_as_errors=false'
    'disable_fieldtrial_testing_config=true'
    'blink_enable_generated_code_formatting=false'
    'ffmpeg_branding="Chrome"'
    'proprietary_codecs=false'
    'rtc_use_pipewire=false'
    'link_pulseaudio=false'
    'use_custom_libcxx=true'
    'use_gnome_keyring=false'
    'use_sysroot=false'
    'use_system_libffi=false'
    'enable_hangout_services_extension=false'
    'enable_widevine=false'
    'enable_nacl=false'
    'use_xkbcommon=false' 
    'use_gtk=false' 
    'use_qt=false'
    "google_api_key=\"$_google_api_key\""
  )

  # Facilitate deterministic builds (taken from build/config/compiler/BUILD.gn)
  CFLAGS+='   -Wno-builtin-macro-redefined'
  CXXFLAGS+=' -Wno-builtin-macro-redefined'
  CPPFLAGS+=' -D__DATE__=  -D__TIME__=  -D__TIMESTAMP__='

  # Do not warn about unknown warning options
  CFLAGS+='   -Wno-unknown-warning-option'
  CXXFLAGS+=' -Wno-unknown-warning-option'

  # Let Chromium set its own symbol level
  CFLAGS=${CFLAGS/-g }
  CXXFLAGS=${CXXFLAGS/-g }

  # https://github.com/ungoogled-software/ungoogled-chromium-archlinux/issues/123
  CFLAGS=${CFLAGS/-fexceptions}
  CFLAGS=${CFLAGS/-fcf-protection}
  CXXFLAGS=${CXXFLAGS/-fexceptions}
  CXXFLAGS=${CXXFLAGS/-fcf-protection}

  # This appears to cause random segfaults when combined with ThinLTO
  # https://bugs.archlinux.org/task/73518
  CFLAGS=${CFLAGS/-fstack-clash-protection}
  CXXFLAGS=${CXXFLAGS/-fstack-clash-protection}

  # https://crbug.com/957519#c122
  CXXFLAGS=${CXXFLAGS/-Wp,-D_GLIBCXX_ASSERTIONS}

  gn gen out/Cronet --args="${_flags[*]}" --export-compile-commands
  ninja -C out/Cronet cronet_static
}

package() {
  cd chromium-$pkgver

  install -D out/Cronet/obj/components/cronet/libcronet_static.a \
    "$pkgdir/usr/lib/libcronet_static.a"
  install -D components/cronet/native/generated/cronet.idl_c.h \
    "$pkgdir/usr/include/cronet/cronet.idl_c.h" 
  install -D components/cronet/native/include/cronet_c.h \
    "$pkgdir/usr/include/cronet/cronet_c.h"
  install -D components/cronet/native/include/cronet_export.h \
    "$pkgdir/usr/include/cronet/cronet_export.h" 
  install -D components/grpc_support/include/bidirectional_stream_c.h \
    "$pkgdir/usr/include/cronet/bidirectional_stream_c.h"
  install -D out/Cronet/compile_commands.json \
    "$pkgdir/usr/share/cronet/compile_commands.json"
}

# vim:set ts=2 sw=2 et:

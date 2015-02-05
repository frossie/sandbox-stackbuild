include ::stdlib
include ::augeas
include ::sysstat


case $::osfamily {
  'Debian': {
    $convience_pkgs = [
      'screen',
      'tree',
      'vim'
    ]

    $pkg_list = [
      # needed for newinstall.sh
      'make',
      # list from https://confluence.lsstcorp.org/display/LSWUG/Prerequisites
      'bison',
      'curl',
      'flex',
      'g++',
      'git',
      'libbz2-dev',
      'libreadline6-dev',
      'libx11-dev',
      'libxt-dev',
      'm4',
      'zlib1g-dev',
      # needed for shapelet tests
      'libxrender1',
      'libfontconfig1',
    ]
  }
  'RedHat': {
    include ::epel
    Class['epel'] -> Package<| provider == 'yum' |>

    $convience_pkgs = [
      'screen',
      'tree',
      'vim-enhanced'
    ]

    $pkg_list = [
      'bison',
      'blas',
      'bzip2', # needed on el7 -- pulled in by bzip2-devel on el6?
      'bzip2-devel',
      'flex',
      'freetype-devel',
      'git', # needed on el6, in @core for others?
      'gcc-c++',
      'gcc-gfortran',
      'libuuid-devel',
      'libXt-devel',
      'ncurses-devel',
      'make',
      'openssl-devel',
      'perl',
      'readline-devel',
      'zlib-devel',
      'patch',
    ]
  }
  default: { fail() }
}

package { $pkg_list: }
package { $convience_pkgs: }

$memoryrequired = to_bytes('16 GB')
$swaprequired = $memoryrequired - to_bytes($::memorysize)

if $swaprequired < to_bytes('128 MB') {
  $newswap = 0
} else {
  $newswap = $swaprequired
}

class { 'swap_file':
  swapfilesize => $newswap,
}

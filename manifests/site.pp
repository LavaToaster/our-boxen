require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::homebrewdir}/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin',
    "/Users/${::boxen_user}/.composer/vendor/bin"
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # core modules, needed for most things
  include dnsmasq
  include git
  include hub
  include brewcask
  include homebrew

  # fail if FDE is not enabled
  if $::root_encrypted == 'no' {
    fail('Please enable full disk encryption and try again')
  }

  # node versions

  # default ruby versions
  ruby::version { '1.9.3': }
  ruby::version { '2.0.0': }
  ruby::version { '2.1.0': }
  ruby::version { '2.1.1': }
  ruby::version { '2.1.2': }

  homebrew::tap { 'caskroom/versions': }
  homebrew::tap { 'homebrew/dupes': }
  homebrew::tap { 'homebrew/php': }

  # common, useful packages
  package {
    [
      'ack',
      'findutils',
      'gnu-tar',
      'zsh',
      'htop',
      'tmux',
      'nodejs',
      'php56',
      'php56-mcrypt',
      'php56-mysqlnd_ms',
      'composer'
    ]:
  }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }

  # Some Required Apps
  package { 'google-chrome'             : provider => 'brewcask' }
  package { 'firefox'                   : provider => 'brewcask' }
  package { 'intellij-idea-bundled-jdk' : provider => 'brewcask' }
  package { 'phpstorm-bundled-jdk'      : provider => 'brewcask' }
  package { 'atom'                      : provider => 'brewcask' }
  package { 'iterm2'                    : provider => 'brewcask' }
  package { 'hipchat'                   : provider => 'brewcask' }
  package { 'gas-mask'                  : provider => 'brewcask' }
  package { 'lastpass'                  : provider => 'brewcask' }
  package { 'microsoft-office365'       : provider => 'brewcask' }
  package { 'virtualbox'                : provider => 'brewcask' }
  package { 'vagrant'                   : provider => 'brewcask' }
  package { 'teamviewer'                : provider => 'brewcask' }
  package { 'sequel-pro-nightly'        : provider => 'brewcask' } 
  package { 'gpgtools'                  : provider => 'brewcask' }
}

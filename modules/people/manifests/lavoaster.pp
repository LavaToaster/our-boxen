class people::lavoaster { 
  include brewcask

  package { 'razer-synapse'   : provider => 'brewcask' }
  package { 'skype'           : provider => 'brewcask' }
  package { 'vmware-fusion'   : provider => 'brewcask' }
  package { 'alfred'          : provider => 'brewcask' }
}

# Class: neptune_agent
# ===========================
#
# Full description of class neptune_agent here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'neptune_agent':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class neptune_agent (
    $agent_user = '',
    $require_sudo = '',
    $endpoint = '',
    $download_url = '',
    $assigned_hostname = ' ',
    $neptune_api_key = '',
    $daemon = ''
  ) inherits neptune_agent::params {

  include neptune_agent::params

  require neptune_agent::params

  # Download agent installer script
  exec {'download_installer':
    command => "curl -sS -L -o /tmp/install_neptune_agent_linux.sh ${neptune_agent::params::download_url}/scripts/linux/install_neptune_agent_linux.sh",
    logoutput => on_failure,
    creates => "/tmp/install_neptune_agent_linux.sh",
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ],
    unless => 'ls /etc/init.d/${neptune_agent::params::daemon}',
    user => "${neptune_agent::params::agent_user}"
  }

  $envs = [ 
    "API_KEY=${neptune_agent::neptune_api_key}", 
    "AGENT_USER=${neptune_agent::params::agent_user}",
    "END_POINT=${neptune_agent::params::endpoint}",
    "REQUIRE_SUDO=${neptune_agent::params::require_sudo}",
    "ASSIGNED_HOST_NAME=${neptune_agent::assigned_hostname}"
  ]

  # Install agent to init.d
  exec {'install_neptune_agent':
    command => "chmod +x /tmp/install_neptune_agent_linux.sh && bash /tmp/install_neptune_agent_linux.sh",
    creates => '/etc/init.d/${neptune_agent::params::daemon}',
    environment => $envs,
    user => "root",
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ],
    unless => 'ls /etc/init.d/${neptune_agent::params::daemon}',
    require => Exec['download_installer']
  }

  # Start the service if not running
  service {'neptune-agentd':
    enable => true,
    ensure => running,
    require => Exec['install_neptune_agent']
  }
}

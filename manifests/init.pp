# Class: neptune_agent
# ===========================
#
# This class contains mechanism to install Neptune agent on a linux server
#
# Parameters
# ----------
#
# * `agent_user`
# The user as which the Neptune.io agent should run on your server.
# You can either choose one of the existing users or give a new user name.
#
# * `require_sudo`
# Flag indicating if the Neptune.io should have sudo previleges or not.
# Set to false by default, means Neptune.io cannot run sudo command.
#
# * `neptune_api_key`
# Your Neptune.io API key. Get this from Neptune.io web app.
#
# * `assigned_hostname`
# If you want to override any of the host names, set this parameter so that
# Neptune.io uses this name instead of `hostname` value from that host.
#
# Examples
# --------
#
# @example
#    class { 'neptune_agent':
#      neptune_api_key => "dummy_api_key",
#      require_sudo => "true"
#    }
#
# Authors
# -------
#
# Neptune Inc <team@neptune.io>
#
# Copyright
# ---------
#
# Copyright 2016 Neptune.io Inc
#
class neptune_agent (
    $agent_user = '',
    $require_sudo = '',
    $endpoint = '',
    $download_url = '',
    $assigned_hostname = '',
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

  if ("${neptune_agent::agent_user}" != "") {
    $user = "AGENT_USER=${neptune_agent::agent_user}"
  } 
  elsif ("${neptune_agent::params::agent_user}" != "") {
    $user = "AGENT_USER=${neptune_agent::params::agent_user}"
  }
  else {
    $user = ''
  }
  
  if ("${neptune_agent::require_sudo}" != "") {
    $sudo = "REQUIRE_SUDO=${neptune_agent::require_sudo}"
  }
  elsif ("${neptune_agent::params::require_sudo}" != "") {
    $sudo = "REQUIRE_SUDO=${neptune_agent::params::require_sudo}"
  }
  else {
    $sudo = ''
  }

  if ("${neptune_agent::assigned_hostname}" != "") {
    $assigned_host = "ASSIGNED_HOST_NAME=${neptune_agent::assigned_hostname}"
  }
  elsif ("${neptune_agent::params::assigned_hostname}" != "") {
    $assigned_host = "ASSIGNED_HOST_NAME=${neptune_agent::params::assigned_hostname}"
  }
  else {
    $assigned_host = ''
  }

  # split into array based on whitespace
  $envs = split("END_POINT=${neptune_agent::params::endpoint} API_KEY=${neptune_agent::neptune_api_key} $sudo $user $assigned_host", '\s+')

  # Install agent to init.d
  exec {'install_neptune_agent':
    command => "chmod +x /tmp/install_neptune_agent_linux.sh && bash /tmp/install_neptune_agent_linux.sh",
    creates => '/etc/init.d/${neptune_agent::params::daemon}',
    environment => $envs,
    user => "root",
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ],
    unless => 'ls /etc/init.d/${neptune_agent::params::daemon}',
    require => Exec['download_installer'],
    logoutput => 'true'
  }

  # Start the service if not running
  service {'neptune-agentd':
    enable => true,
    ensure => running,
    require => Exec['install_neptune_agent']
  }
}

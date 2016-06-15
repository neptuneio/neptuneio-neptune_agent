# Class neptune_neptune_agent::params
# This class contains configurable parameters of Neptune agent installation

class neptune_agent::params {
  # Change the variables below

  # Mandatory
  $neptune_api_key ='Your Neptuneio API key here'

  # Non-mandatory
  $assigned_hostname = ''
  $require_sudo = 'false'
  $agent_user = 'neptune'

  # Don't change the variables below
  $download_url = 'https://raw.githubusercontent.com/neptuneio/neptune-agent/prod'
  $endpoint = 'www.neptune.io'
  $daemon = 'neptune-agentd'
}

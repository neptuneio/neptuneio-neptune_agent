# neptune_agent

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with neptune_agent](#setup)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This puppet module installs Neptune agent on a linux server.
Check https://github.com/neptuneio/neptune-agent for the agent repo.

This module:

1. Creates a new user (neptune unless you specified differently) if the user does not exist. 
1. Creates a directory "agent" for all files related to the agent under user's home directory.
1. Downloads latest version of agent, daemon and publishes them to init.d
1. Start neptuneio agent as "neptune-agentd" service.

## Setup

A brief setup is needed on your puppet master to configure parameters of your neptune agent

Open manifests/params.pp and configure the variables as follows

    $neptune_api_key = 'Your Neptuneio API key here',
    $require_sudo = 'true'

## Usage

    include neptune_agent (if you have given the API key in params.pp)

OR

    class { 'neptune_agent':
      neptune_api_key => 'Your Neptune API key here',
      assigned_host_name = 'Your custom hostname if any, or an empty string',
      require_sudo => 'true'  # Optional, defaults to false
    }

## Reference

Main class:
    neptune_agent

Parameters class:
    neptune_agent::params

## Limitations

OS Support:
 Debian, Ubuntu, Redhat, CentOS, Amazon Linux

## Development

Please clone, make changes and send in a pull request.

## Release Notes/Contributors/Etc. **Optional**

## Release Notes
v 0.1.0

# Author
Neptune.io Inc.

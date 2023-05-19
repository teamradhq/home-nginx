# Home Nginx

This repository contains a collection of tools and templates for working with `nginx` on a home network server. 

It contains tools to:

- Configure `nginx`
    - Html
    - PHP
    - Local Proxy
- Manage SSL certificates
    - Certificate Authority
    - Certificate Creation
    - Trusting Certificates on Clients
- Configure Ubuntu Services
    - `docker-compose`

## Getting Started

Each directory contains a `README.md` with more detailed instructions on its topic.

### Certificates

The `certificates` directory provides scripts for creating a certificate authority and creating certificates 
signed by that authority. It's possible to use this location as a place to store certificates as they should 
be ignored by git.

## Sites Available

Add `nginx` site configurations here. By default, all `conf` files in this directory will be ignored by git.
If you want to commit your configurations to source, it's recommended to fork this to a private repository.

## Templates

Boilerplate for common `nginx` configurations and ubuntu services.



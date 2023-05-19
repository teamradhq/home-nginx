# Certificates

## Setup

Copy the `env.example` file to `.env` and customise the values to suit your needs. 

Every variable in the example file needs to be set with a valid value.

## Functions

Place any shared script logic in `functions.sh`. This script should not be executed directly, but rather 
sourced by other scripts:

```bash
source ./functions.sh
source .env
check-env
```

## Scripts

### Creating a Certificate Authority

This script will create the root certificate authority (CA) that can be used for signing other certificates.

```bash
create-ca.sh {passphrase}
```

### Creating a Certificate

TODO

## Trusting Certificates on Clients

TODO

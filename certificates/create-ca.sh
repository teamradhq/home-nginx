#!/usr/bin/env bash

###############################################################################
#                                                                             #
#                         Create a Certificate Authority                      #
#                                                                             #
#   Use this script to create a self signed certificate authority (CA) that   #
#   your can use to sign certificates for your local servers.                 #
#                                                                             #
###############################################################################

source .env

# Ensure env requirements are met
if [[ -z "$CA_PREFIX" ]]
then
  echo "No .env value set for CA_PREFIX"
  exit 1
fi

# Verify that a passphrase was supplied to the script before setting variables
if [ -z "$1" ]
then
  echo "No passphrase supplied. Please provide a passphrase as an argument."
  echo "Usage:      $0 <passphrase>"
  exit 1
fi

PASSPHRASE=$1
CA="./CA/$CA_PREFIX.CA-certificate.pem"
CA_KEY="./CA/$CA_PREFIX.CA-key.pem"

# Don't proceed if the CA files are read-only as this indicates the CA should not be overwritten.
FILES=("$CA" "$CA_KEY")
for file in "${FILES[@]}"; do
  if [[ -e "$file" && ! -w "$file" ]]; then
    echo "The file $file is read-only."
    echo "To ensure that an existing CA is not overwritten, please remove the file and try again."
    exit 2
  fi
done

# Ensure the CA directory exists
mkdir -p ./CA

# Generate the RSA Key
openssl genrsa -aes256 -passout pass:"$PASSPHRASE" -out "$CA_KEY" 4096

# Generate the CA
openssl req -new -x509 -sha256 -days 365 \
  -subj "/C=AU/ST=Victoria/L=Melbourne/O=Team Rad HQ/OU=The Mothership/CN=Team Rad/emailAddress=admin@gateway.local" \
  -key "$CA_KEY" \
  -passin pass:"$PASSPHRASE" \
  -out "$CA"

chmod 444 "$CA" "$CA_KEY"

#!/usr/bin/env bash
source ./functions.sh

###############################################################################
#                                                                             #
#                         Create a Certificate Authority                      #
#                                                                             #
#   Use this script to create a self signed certificate authority (CA) that   #
#   your can use to sign certificates for your local servers.                 #
#                                                                             #
###############################################################################

source .env
check-env

# Verify that a passphrase was supplied to the script before setting variables
if [ -z "$1" ]
then
  echo "No passphrase supplied. Please provide a passphrase as an argument."
  echo "Usage:      $0 <passphrase>"
  exit 1
fi

PASSPHRASE=$1

# Don't proceed if the CA files are read-only as this indicates the CA should not be overwritten.
FILES=("$CA_CERTIFICATE" "$CA_KEY")
for file in "${FILES[@]}"; do
  check-file-is-writeable "$file" \
    "To ensure that an existing CA is not unintentionally overwritten, please remove the file and try again."
done

mkdir -p ./CA

# Generate the RSA Key
openssl genrsa -aes256 -passout pass:"$PASSPHRASE" -out "$CA_KEY" 4096

# Generate the CA
openssl req -new -x509 -sha256 -days 365 \
  -subj "/C=$CA_COUNTRY/ST=$CA_STATE/L=$CA_LOCALITY/O=$CA_ORGANISATION/OU=$CA_UNIT/CN=$CA_NAME/emailAddress=$CA_EMAIL" \
  -key "$CA_KEY" \
  -passin pass:"$PASSPHRASE" \
  -out "$CA_CERTIFICATE"

chmod 444 "$CA_CERTIFICATE" "$CA_KEY"

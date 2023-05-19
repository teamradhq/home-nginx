#!/usr/bin/env bash

if [ -z "$1" ]
then
  echo "No passphrase supplied. Please provide a passphrase as an argument."
  echo "Usage:      $0 <passphrase>"
  exit 1
fi

PASSPHRASE=$1
CA="./CA/gateway.local.CA-certificate.pem"
CA_KEY="./CA/gateway.local.CA-key.pem"

FILES=("$CA" "$CA_KEY")
for file in "${FILES[@]}"; do
  if [[ -e "$file" && ! -w "$file" ]]; then
    echo "The file $file is read-only."
    echo "To ensure that an existing CA is not overwritten, please remove the file and try again."
    exit 2
  fi
done

mkdir -p ./CA
openssl genrsa -aes256 -passout pass:"$PASSPHRASE" -out $CA_KEY 4096
openssl req -new -x509 -sha256 -days 365 -subj "/C=AU/ST=Victoria/L=Melbourne/O=Team Rad HQ/OU=The Mothership/CN=Team Rad/emailAddress=admin@gateway.local" -key $CA_KEY -passin pass:"$PASSPHRASE" -out $CA
chmod 444 $CA $CA_KEY



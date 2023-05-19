#!/usr/bin/env bash

###############################################################################
#                                                                             #
#                              Create a Certificate                           #
#                                                                             #
#   Use this script to create a self signed certificate using the (CA) that   #
#   was created by the create-ca.sh script.                                   #
#                                                                             #
###############################################################################

source .env

USAGE="Usage: $0 <cert-name> <passphrase> [--ips=<ip1,ip2,...>] [--domains=<domain1,domain2,...>]"

if [[ -z "$CA_PREFIX" ]]
then
  echo "No .env value set for CA_PREFIX"
  exit 1
fi

CA="./CA/$CA_PREFIX.CA-certificate.pem"
CA_KEY="./CA/$CA_PREFIX.CA-key.pem"

# Ensure that the CA files exist
FILES=("$CA" "$CA_KEY")
for file in "${FILES[@]}"; do
  if [[ ! -e "$file" ]]; then
    echo "The file $file does not exist."
    echo "A self signed certificate cannot be created without the Certificate Authority"
    exit 2
  fi
done

# Ensure all required arguments are supplied.
if [[ -z "$1" ]]
then
  echo "Please provide a certificate name."
  echo "$USAGE"
  exit 3
fi

if [[ -z "$2" ]]
then
  echo "Please provide the CA passphrase."
  echo "$USAGE"
  exit 4
fi

CERT=$1
PASSPHRASE=$2
shift 2

# Set default values for IPS and DOMAINS
IPS=""
DOMAINS=""

# Iterate through remaining command line arguments.
for ARG in "$@"
do
  # Use parameter expansion to get values after '='.
  case "$ARG" in
    --ips=*)
      IPS="${ARG#*=}"
      ;;
    --domains=*)
      DOMAINS="${ARG#*=}"
      ;;
    *)
      echo "Unknown argument: $ARG"
      echo "Usage: $0 <cert-name> [--ips=<ip1,ip2,...>] [--domains=<domain1,domain2,...>]"
      exit 5
      ;;
  esac
done

# Create arrays of IP addresses and domains.
IFS=',' read -ra IP_ARRAY <<< "$IPS"
IFS=',' read -ra DOMAIN_ARRAY <<< "$DOMAINS"

# Generate the subjectAltName string
SAN="subjectAltName="
for IP in "${IP_ARRAY[@]}"; do
  SAN="${SAN}IP:${IP},"
done

for DOMAIN in "${DOMAIN_ARRAY[@]}"; do
  SAN="${SAN}DNS:${DOMAIN},"
done

# Remove trailing comma
SAN="${SAN%,}"

RSA_KEY="$CERT.cert-key.pem"
CSR="$CERT.cert.csr"
CERTIFICATE="$CERT.cert.pem"

# Generate RSA Key
echo "Creating RSA Key:     $RSA_KEY"
openssl genrsa -out "$RSA_KEY" 4096

# Generate CSR
echo "Creating CSR:         $RSA_KEY"
openssl req -new -sha256 -subj "/CN=$CERT" -key "$RSA_KEY" -out "$CSR"

# Configure extfile
echo "Creating extfile"
echo "$SAN" > extfile.cnf && \
echo "extendedKeyUsage=serverAuth" >> extfile.cnf

# Generate Certificate
echo "Creating Certificate: $CERTIFICATE"
openssl x509 -req -sha256 -days 365  -CAcreateserial \
  -in "$CSR" \
  -CA "$CA" \
  -CAkey "$CA_KEY" \
  -out "$CERTIFICATE" \
  -extfile extfile.cnf \
  -passin pass:"$PASSPHRASE" \
  || (echo fail && exit 6)


echo "Created Certificate:  $CERTIFICATE"
rm extfile.cnf
chmod 444 ./"$CERT".*
openssl x509 -in "$CERTIFICATE" -noout -issuer -subject -dates


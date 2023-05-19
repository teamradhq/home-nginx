# Check an environment variable is set, exiting with error
# message if it's not.
#
# Usage:
#     check-env {key} {value}
#
check-env-var() {
  local key=$1
  local value=$2

  if [[ -z "$value" ]]
  then
    echo "No .env value set for $key"
    exit 1
  fi
}

# Check all required environment variables are set
check-env() {
  check-env-var "CA_PREFIX" "$CA_PREFIX"
  check-env-var "CA_COUNTRY" "$CA_COUNTRY"
  check-env-var "CA_STATE" "$CA_STATE"
  check-env-var "CA_LOCALITY" "$CA_LOCALITY"
  check-env-var "CA_ORG" "$CA_ORG"
  check-env-var "CA_UNIT" "$CA_UNIT"
  check-env-var "CA_NAME" "$CA_NAME"
  check-env-var "CA_EMAIL" "$CA_EMAIL"
  check-env-var "CA_CERTIFICATE" "$CA_CERTIFICATE"
  check-env-var "CA_KEY" "$CA_KEY"
}

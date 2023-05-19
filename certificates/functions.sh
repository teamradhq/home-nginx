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

# Echo non-empty message
#
# Usage:
#    if-message {message}
#    if-message
#
if-message() {
  if [[ -n "$1" ]]; then
    echo "$1"
  fi
}

# Check a file exist, exiting with error message if not.
#
# Usage:
#    check-file-exists {file}
#    check-file-exists {file} {message}
#
check-file-exists() {
  local file=$1

  if [[ ! -e "$file" ]]; then
    echo "The file $file does not exist."
    if-message "$2"
    exit 2
  fi
}

# Check a file is writeable, exiting with error message if it's not.
#
# Usage:
#    check-file-is-writeable {file}
#    check-file-is-writeable {file} {message}
#
check-file-is-writeable() {
  local file=$1

  if [[ -e "$file" && ! -w "$file" ]]; then
    echo "The file $file is read-only."
    if-message "$2"
    exit 3
  fi
}

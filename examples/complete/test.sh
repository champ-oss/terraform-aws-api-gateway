set -e

# Validate root endpoint with api key
export URL=$ROOT_ENDPOINT
export AUTH_TOKEN=$API_KEY_VALUE
export EXPECTED="successful"
bash http_test.sh

# Validate root endpoint without api key
export URL=$ROOT_ENDPOINT
export AUTH_TOKEN=""
export EXPECTED="Forbidden"
bash http_test.sh

# Validate /test endpoint with api key
export URL=$TEST_PATH_ENDPOINT
export AUTH_TOKEN=$API_KEY_VALUE
export EXPECTED="successful"
bash http_test.sh

# Validate /test endpoint without api key
export URL=$TEST_PATH_ENDPOINT
export AUTH_TOKEN=""
export EXPECTED="Forbidden"
bash http_test.sh
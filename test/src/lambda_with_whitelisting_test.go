package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"net/http"
	"testing"
)

func TestLambdaWithWhitelisting(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir:  "../../examples/lambda_with_whitelisting",
		BackendConfig: map[string]interface{}{},
		EnvVars:       map[string]string{},
		Vars:          map[string]interface{}{},
	}
	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	apiKey := terraform.Output(t, terraformOptions, "api_key_value")

	rootEndpoint := terraform.Output(t, terraformOptions, "root_endpoint")
	assert.NoError(t, checkHttpStatusAndBody(t, rootEndpoint, apiKey, "successful", http.StatusOK))
	assert.NoError(t, checkHttpStatusAndBody(t, rootEndpoint, "", "{\"message\":\"Forbidden\"}", http.StatusForbidden))

	testPathEndpoint := terraform.Output(t, terraformOptions, "test_path_endpoint")
	assert.NoError(t, checkHttpStatusAndBody(t, testPathEndpoint, apiKey, "successful", http.StatusOK))
	assert.NoError(t, checkHttpStatusAndBody(t, testPathEndpoint, "", "{\"message\":\"Forbidden\"}", http.StatusForbidden))
}

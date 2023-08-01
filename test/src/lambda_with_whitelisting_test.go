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

	apiGatewayEndpoint := terraform.Output(t, terraformOptions, "endpoint")
	apiKey := terraform.Output(t, terraformOptions, "api_key_value")

	assert.NoError(t, checkHttpStatusAndBody(t, apiGatewayEndpoint, apiKey, "successful", http.StatusOK))
}

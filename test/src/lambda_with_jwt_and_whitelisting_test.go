package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"net/http"
	"testing"
)

func TestLambdaWithJwtAndWhitelisting(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir:  "../../examples/lambda_with_jwt_and_whitelisting",
		BackendConfig: map[string]interface{}{},
		EnvVars:       map[string]string{},
		Vars:          map[string]interface{}{},
	}
	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	// Check endpoint that uses whitelisting
	apiGatewayEndpoint1 := terraform.Output(t, terraformOptions, "api_gateway_endpoint1")
	assert.NoError(t, checkHttpStatusAndBody(t, apiGatewayEndpoint1, "", "successful", http.StatusOK))

	// Check endpoint that uses JWT
	keycloakEndpoint := terraform.Output(t, terraformOptions, "keycloak_endpoint")
	keycloakPassword := terraform.Output(t, terraformOptions, "keycloak_admin_password")
	apiGatewayEndpoint2 := terraform.Output(t, terraformOptions, "api_gateway_endpoint2")
	jwt := getKeycloakJwt(t, keycloakEndpoint, "master", "admin", keycloakPassword)
	assert.NoError(t, checkHttpStatusAndBody(t, apiGatewayEndpoint2, jwt, "successful", http.StatusOK))
}

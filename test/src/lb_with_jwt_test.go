package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"net/http"
	"testing"
)

func TestLbWithJwt(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir:  "../../examples/lb_with_jwt",
		BackendConfig: map[string]interface{}{},
		EnvVars:       map[string]string{},
		Vars:          map[string]interface{}{},
	}
	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	keycloakPassword := terraform.Output(t, terraformOptions, "keycloak_admin_password")
	keycloakEndpoint := terraform.Output(t, terraformOptions, "keycloak_endpoint")
	apiGatewayEndpoint := terraform.Output(t, terraformOptions, "api_gateway_endpoint")

	// Validate that JWT auth is required
	assert.NoError(t, checkHttpStatusAndBody(t, apiGatewayEndpoint, "", "{\"message\":\"Unauthorized\"}", http.StatusUnauthorized))

	// Get a JWT from Keycloak and test a successful request
	jwt := getKeycloakJwt(t, keycloakEndpoint, "master", "admin", keycloakPassword)
	assert.NoError(t, checkHttpStatusAndBody(t, apiGatewayEndpoint, jwt, "Hello world", http.StatusOK))
}

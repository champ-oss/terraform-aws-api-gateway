package test

import (
	"context"
	"fmt"
	"github.com/Nerzal/gocloak/v13"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"io/ioutil"
	k8sStrings "k8s.io/utils/strings"
	"net/http"
	"os"
	"strings"
	"testing"
	"time"
)

const (
	retryDelaySeconds = 5
	retryAttempts     = 36
)

func TestLambdaWithJwt(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../../examples/lambda_with_jwt",
		BackendConfig: map[string]interface{}{
			"bucket": os.Getenv("TF_STATE_BUCKET"),
			"key":    os.Getenv("TF_VAR_git") + "-lambda_with_jwt",
		},
		EnvVars: map[string]string{},
		Vars:    map[string]interface{}{},
	}
	//defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	keycloakPassword := terraform.Output(t, terraformOptions, "keycloak_admin_password")
	keycloakEndpoint := terraform.Output(t, terraformOptions, "keycloak_endpoint")
	apiGatewayEndpoint := terraform.Output(t, terraformOptions, "api_gateway_endpoint")

	// Validate that JWT auth is required
	assert.NoError(t, checkHttpStatusAndBody(t, apiGatewayEndpoint, "", "{\"message\":\"Unauthorized\"}", http.StatusUnauthorized))

	// Get a JWT from Keycloak and test a successful request
	jwt := getKeycloakJwt(keycloakEndpoint, "master", "admin", keycloakPassword)
	fmt.Println("Keycloak Jwt:", k8sStrings.ShortenString(jwt, 10))
	assert.NoError(t, checkHttpStatusAndBody(t, apiGatewayEndpoint, jwt, "successful", http.StatusOK))
}

func getKeycloakJwt(basePath, realm, username, password string) string {
	fmt.Println("getting JWT from:", basePath)
	client := gocloak.NewClient(basePath)
	jwt, err := client.LoginAdmin(context.TODO(), username, password, realm)
	if err != nil {
		fmt.Println(err)
		return ""
	}
	return jwt.AccessToken
}

func checkHttpStatusAndBody(t *testing.T, url, authToken, expectedBody string, expectedHttpStatus int) error {
	t.Logf("checking %s", url)
	client := &http.Client{}
	request, _ := http.NewRequest("GET", url, nil)
	request.Header.Set("Authorization", authToken)

	for i := 0; ; i++ {
		resp, err := client.Do(request)
		if err != nil {
			t.Log(err)
		} else {
			t.Logf("StatusCode: %d", resp.StatusCode)
			body, err := ioutil.ReadAll(resp.Body)
			if err != nil {
				t.Log(err)
			} else {
				t.Logf("body: %s", body)
				if resp.StatusCode == expectedHttpStatus && strings.Contains(string(body), expectedBody) {
					return nil
				}
			}
		}

		if i >= (retryAttempts - 1) {
			return fmt.Errorf("timed out while retrying")
		}

		t.Logf("Retrying in %d seconds...", retryDelaySeconds)
		time.Sleep(time.Second * retryDelaySeconds)
	}
}

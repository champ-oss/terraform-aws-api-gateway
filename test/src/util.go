package test

import (
	"context"
	"fmt"
	"github.com/Nerzal/gocloak/v13"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"io/ioutil"
	k8sStrings "k8s.io/utils/strings"
	"net/http"
	"strings"
	"testing"
	"time"
)

const (
	retryDelaySeconds = 5
	retryAttempts     = 36
)

func getKeycloakJwt(t *testing.T, basePath, realm, username, password string) string {
	t.Logf("getting JWT from: %s", basePath)
	client := gocloak.NewClient(basePath)
	jwt, err := client.LoginAdmin(context.TODO(), username, password, realm)
	if err != nil {
		fmt.Println(err)
		return ""
	}
	t.Logf("Keycloak Jwt: %s", k8sStrings.ShortenString(jwt.AccessToken, 10))
	return jwt.AccessToken
}

func checkHttpStatusAndBody(t *testing.T, url, authToken, expectedBody string, expectedHttpStatus int) error {
	t.Logf("checking %s", url)
	client := &http.Client{}
	request, _ := http.NewRequest("GET", url, nil)
	request.Header.Set("Authorization", authToken)
	request.Header.Set("X-API-KEY", authToken)

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

func destroy(t *testing.T, options *terraform.Options) {
	t.Log("removing keycloak resources from state")
	_, _ = terraform.RunTerraformCommandE(t, options, "state", "rm", "module.keycloak.time_sleep.this")
	_, _ = terraform.RunTerraformCommandE(t, options, "state", "rm", "module.keycloak.data.keycloak_realm.this")
	_, _ = terraform.RunTerraformCommandE(t, options, "state", "rm", "module.keycloak.data.keycloak_openid_client_scope.this")
	_, _ = terraform.RunTerraformCommandE(t, options, "state", "rm", "module.keycloak.keycloak_openid_audience_protocol_mapper.this")
	_, _ = terraform.DestroyE(t, options)
}

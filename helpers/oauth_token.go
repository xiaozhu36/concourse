package helpers

import (
	"errors"

	"github.com/sclevine/agouti"
)

func OauthToken(atcURL string, creds *oauthAuthCredentials) (string, error) {
	agoutiDriver := agouti.ChromeDriver(agouti.Debug)
	err := agoutiDriver.Start()
	if err != nil {
		return "", err
	}

	page, err := agoutiDriver.NewPage()
	if err != nil {
		return "", err
	}

	defer page.Destroy()

	var oauthToken string
	switch creds.Provider {
	case githubProvider:
		oauthToken, err = getGithubOauthToken(atcURL, creds, page)
	}

	if err != nil {
		return "", err
	}
	if oauthToken == "" {
		return "", errors.New("Unable to generate oauth token, oauth provider not identified")
	}
	return oauthToken, nil
}

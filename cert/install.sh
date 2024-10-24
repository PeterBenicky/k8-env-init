# https://wiki.one.int.sap/wiki/pages/viewpage.action?pageId=4401470738#FOSDataProductLifecycle&Onboarding-ImplementationGuidelineforOrchestrationService

# meeting starting at 47:12.
# https://sapnam-my.sharepoint.com/personal/roel_stalman_sap_com/_layouts/15/stream.aspx?id=%2Fpersonal%2Froel%5Fstalman%5Fsap%5Fcom%2FDocuments%2FRecordings%2FFOS%20Monthly%20Demo%2D20240926%5F150334%2DMeeting%20Recording%2Emp4&referrer=StreamWebApp%2EWeb&referrerScenario=AddressBarCopied%2Eview%2E916133c7%2De631%2D4ad0%2Da6e6%2Daea0bc4cb8b0



token=$(curl -s -m 30 -X POST \
  $authUrl \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'Accept: application/json' \
  -d "grant_type=client_credentials&token_format=bearer" \
  -d "client_id="$clientId \
  -d "client_secret="$clientSecret | jq -r '.access_token')

openssl genpkey -aes-256-cbc -algorithm RSA -pkeyopt rsa_keygen_bits:3072 -out my-private-key.pem \
    -pass "pass:$pemPassPhrase"

openssl req -new -sha256 -key my-private-key.pem -out my-csr.pem \
   -subj "$subjectPattern" \
   -passin "pass:$pemPassPhrase"

csr=$(< my-csr.pem)

curl -s -m 30 -X POST \
  "$certUrl" \
  -H "Authorization: Bearer $token" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "$(jq -n --arg csr "$csr" '{csr: {value: $csr}, "policy": "sap-cloud-platform-clients"}')" \
  > my-client-certificate-chain-response.json


jq -r '.["certificateChain"]["value"]' my-client-certificate-chain-response.json > my-client-certificate_pkcs7.pem
openssl pkcs7 -print_certs -text -noout -in my-client-certificate_pkcs7.pem
openssl pkcs7 -print_certs -in my-client-certificate_pkcs7.pem -out my-client-certificate_chain.pem
openssl x509 -in my-client-certificate_chain.pem -out my-client-certificate.pem
openssl rsa -in my-private-key.pem -out decrypted_private_key.pem -passin "pass:$pemPassPhrase"

echo "Client certificate and private key generated successfully."
echo ""
echo "Go to: https://eu10-stage-2oxeiujj.hana-tooling.ingress.orchestration.prod-eu10.hanacloud.ondemand.com/hrtt/sap/hana/cst/catalog/cockpit-index.html"
echo "S4PCE_EU10_0000005 Rest Api Endpoint: f92c740d-69f2-4ced-b713-49ae850f804b.files.hdl.prod-eu10.hanacloud.ondemand.com"
echo ""
cat my-client-certificate_chain.pem
echo ""
cat decrypted_private_key.pem


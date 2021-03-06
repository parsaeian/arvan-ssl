#!/bin/bash

# Get your API key from https://npanel.arvancloud.com/profile/api-keys
API_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

echo "ADD TXT: $CERTBOT_VALIDATION"

# Create TXT record
CREATE_DOMAIN="_acme-challenge.$CERTBOT_DOMAIN"
RECORD_ID=$(curl -s -X POST "https://napi.arvancloud.com/cdn/4.0/domains/$CERTBOT_DOMAIN/dns-records" \
     -H     "Authorization: $API_KEY" \
     -H     "Content-Type: application/json" \
     --data '{"type":"TXT","name":"'"$CREATE_DOMAIN"'","value":{"text": "'"$CERTBOT_VALIDATION"'"},"ttl":120}' \
             | python -c "import sys,json;print(json.load(sys.stdin)['data']['id'])")
             
# Save info for cleanup
if [ ! -d /tmp/CERTBOT_$CERTBOT_DOMAIN ];then
        mkdir -m 0700 /tmp/CERTBOT_$CERTBOT_DOMAIN
fi
echo $RECORD_ID >> /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_IDS

# Sleep to make sure the change has time to propagate over to DNS
sleep 31

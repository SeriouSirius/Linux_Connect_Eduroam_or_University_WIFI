#!/usr/bin/env bash

# 1. Delete old failed configurations (to prevent conflicts)
nmcli connection delete eduroam 2> /dev/null

# 2. Create a highly compatible eduroam connection
# Note: The identity for eduroam must include the full domain suffix (e.g., @hkmu.edu.hk, @polyu.edu.hk, etc.)
sudo nmcli con add \
  type wifi \
  con-name "eduroam" \
  ssid "eduroam" \
  wifi-sec.key-mgmt wpa-eap \
  802-1x.eap peap \
  802-1x.phase1-auth-peapver 0 \
  802-1x.phase1-auth-flags 32 \
  802-1x.phase2-auth mschapv2 \
  802-1x.identity "YOUR_SCHOOL_EMAIL" \
  802-1x.password "YOUR_SCHOOL_EMAIL_PASSWORD" \
  802-1x.domain-suffix-match "YOUR_SCHOOL_WIFI_DOMAIN"\
  802-1x.password-flags 0 \
  802-1x.system-ca-certs no

# 3. Activate the connection
nmcli con up eduroam

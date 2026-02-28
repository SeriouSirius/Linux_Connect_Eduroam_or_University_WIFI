#!/usr/bin/env bash

# 1. Clean up old failed configurations
nmcli connection delete HKMU 2> /dev/null

# 2. Create compatible configuration
# Key parameter explanations:
# phase1-auth "peapver=0" -> Force use of legacy PEAP v0 (core fix)
# password-flags 0        -> Disable keyring, store password directly (resolve pop-up loop)
# system-ca-certs no      -> Bypass mandatory CA certificate validation
sudo nmcli con add \
  type wifi \
  con-name "HKMU" \
  ssid "HKMU" \
  wifi-sec.key-mgmt wpa-eap \
  802-1x.eap peap \
  802-1x.phase1-auth-peapver 0 \
  802-1x.phase1-auth-flags 32 \
  802-1x.phase2-auth mschapv2 \
  802-1x.identity "YOUR_STUDENT_ID(s1234567)" \
  802-1x.password "YOUR_PASSWORD" \
  802-1x.password-flags 0 \
  802-1x.system-ca-certs no

# 3. Connect immediately
nmcli con up HKMU

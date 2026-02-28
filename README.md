# This guide is designed to help Linux users resolve issues connecting to the **eduroam** global roaming network or the **HKMU** campus network.

[English](README.md) | [繁體中文](README.zh-TW.md) | [簡體中文](README.zh-CN.md)

---

## 1. Eduroam Linux Connection Fix Guide (Unofficial Solution)

The configuration requirements for eduroam are stricter than those for regular campus networks, and Linux users often encounter issues such as default protocol versions being too new or certificate validation being impossible to bypass. This script resolves these problems by forcing compatibility mode.

### Target Users
- HKMU students/staff (using `sxxxxxx@hkmu.edu.hk`)
- Linux users from other universities using eduroam (simply replace the account suffix)

### ⚡ Core Fix Principles
1. **PEAP Version 0**: Force downgrade the protocol version to resolve handshake failures with legacy RADIUS servers.
2. **No CA Cert**: Bypass the Linux graphical interface's requirement to upload a certificate.
3. **Password Flags**: Disable keyring storage to prevent infinite password pop-up windows caused by permission issues.

### 🚀 Quick Connection Commands

Please **copy the entire block** of commands below into your Terminal.

**⚠️ Note: Before running, manually modify `YOUR_SCHOOL_EMAIL`, `YOUR_SCHOOL_WIFI_DOMAIN`, and `YOUR_SCHOOL_EMAIL_PASSWORD` in the commands.**

```bash
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
```

---

## 2. HKMU Wi-Fi Linux Connection Guide (Unofficial Solution)

### 🔴 Symptoms
- The connection keeps spinning and eventually disconnects.
- Repeated password pop-up windows appear, even when the password is correct.
- The "Save" button in the graphical interface is grayed out, forcing certificate upload.
- System logs (`journalctl`) show `Association took too long` or `secrets were required but not provided`.

### 🟢 Root Cause Analysis
1. **Protocol Mismatch**: The school’s RADIUS server uses the older **PEAP v0** protocol, while modern Linux NetworkManager defaults to attempting PEAP v1, leading to handshake failures.
2. **Certificate Validation Mechanism**: The graphical interface forces CA certificate upload, making configuration saving impossible without the correct certificate.
3. **Keyring Issues**: NetworkManager sometimes fails to correctly read passwords from the system keyring, causing infinite pop-up loops.

### 🚀 One-Click Fix Commands (Recommended)

Open your Terminal and copy and modify the following commands based on your network needs (HKMU or eduroam).

#### Connecting to "HKMU" (Commonly used on campus)

Replace `s1234567` with your student ID and `your_password` with your Single Password.

```bash
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
```

#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "Run this script as root or with sudo."
  exit 1
fi

apt update
apt install -y fontconfig openjdk-21-jre wget ca-certificates curl git rsync tar nginx

install -d -m 0755 /etc/apt/keyrings
wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  > /etc/apt/sources.list.d/jenkins.list

apt update
apt install -y jenkins

systemctl enable jenkins
systemctl start jenkins

if command -v ufw >/dev/null 2>&1; then
  ufw allow 8080/tcp || true
fi

cat <<INFO
Jenkins installed.

Open:
  http://YOUR_VPS_IP:8080

Initial admin password:
  sudo cat /var/lib/jenkins/secrets/initialAdminPassword

Next:
  1. Install suggested plugins.
  2. Create a Pipeline job.
  3. Use "Pipeline script from SCM".
  4. Git repository: https://github.com/kinghh-dev/kinghh-web.git
  5. Branch: */master
  6. Script Path: Jenkinsfile
INFO

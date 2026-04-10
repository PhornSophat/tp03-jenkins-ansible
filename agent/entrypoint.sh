#!/usr/bin/env bash
set -euo pipefail

JENKINS_HOME_DIR="/home/jenkins"
SSH_DIR="${JENKINS_HOME_DIR}/.ssh"
AUTHORIZED_KEYS_FILE="${SSH_DIR}/authorized_keys"

mkdir -p "${SSH_DIR}"
touch "${AUTHORIZED_KEYS_FILE}"

if [[ -n "${JENKINS_AGENT_SSH_PUBKEY:-}" ]]; then
    printf '%s\n' "${JENKINS_AGENT_SSH_PUBKEY}" > "${AUTHORIZED_KEYS_FILE}"
fi

chown -R jenkins:jenkins "${JENKINS_HOME_DIR}"
chmod 700 "${SSH_DIR}"
chmod 600 "${AUTHORIZED_KEYS_FILE}"

if [[ ! -f /etc/ssh/ssh_host_rsa_key ]]; then
    ssh-keygen -A
fi

exec "$@"

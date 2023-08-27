#!/bin/bash

# Function to generate a random 4-digit number
generate_random_id() {
  echo $((1000 + RANDOM % 9000))
}

# Parse command line arguments
while getopts "h:t:" opt; do
  case $opt in
    h) H="$OPTARG" ;;
    t) T="$OPTARG" ;;
    \?) echo "Usage: $0 -h <URL> -t <TOKEN>" >&2; exit 1 ;;
  esac
done

# Generate a random 4-digit number for ID
ID=$(generate_random_id)

# Append configuration to /etc/gitlab-runner/config.toml
cat << EOF | sudo tee -a /etc/gitlab-runner/config.toml > /dev/null
[[runners]]
  name = "docker-runner"
  url = "$H"
  id = $ID
  token = "$T"
  token_obtained_at = 2023-08-27T08:28:56Z
  token_expires_at = 0001-01-01T00:00:00Z
  executor = "docker"
  [runners.cache]
    MaxUploadedArchiveSize = 0
  [runners.docker]
    tls_verify = false
    image = "alpine:latest"
    privileged = true
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    volumes = ["/var/run/docker.sock:/var/run/docker.sock", "/cache"]
    shm_size = 0
EOF

echo "Configuration appended to /etc/gitlab-runner/config.toml"


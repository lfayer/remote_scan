#!/usr/bin/env bash

# list of ssh aliases for servers to scan
server_list=(
 'example1'
 'example2'
)

# local dir where this package is installed (configured for MacOS)
base_dir="/Users/${USER}/remote_scan"

# make sure local utilities/directories are present
test -f "${base_dir}/bin/grype" || source <(curl https://raw.githubusercontent.com/anchore/grype/main/install.sh)
mkdir -pv "${base_dir}"/{grype_output,sbom}

# scan each server and process output through grype
for server in "${server_list[@]}"; do
  output_file="${server}-sbom.json"
  printf -- 'Working on %s.\n' "$server"
ssh "$server" <<'EOF'
  test -f "$HOME/bin/syft" || source <(curl https://raw.githubusercontent.com/anchore/syft/main/install.sh)
  bin/syft packages dir:/opt/ -o json --file output.json
EOF
  scp "${server}:~/output.json" "${base_dir}/sbom/${output_file}"
  "${base_dir}/bin/grype" sbom:"${base_dir}/sbom/${output_file}" > "${base_dir}/grype_output/${server}"
done

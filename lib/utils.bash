#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/stefanprodan/timoni"
TOOL_NAME="timoni"
TOOL_TEST="timoni --help"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

get_platform() {
  uname | tr '[:upper:]' '[:lower:]'
}

get_arch() {
  local arch; arch=$(uname -m | tr '[:upper:]' '[:lower:]')
  case ${arch} in
  arm64) # m1 macs
    arch='arm64';;
  aarch64) # all other arm64 devices
    arch='arm64';;
  x86_64)
    arch='amd64';;
  *) # fallback
    arch='amd64';;
  esac

  echo "${arch}"
}

# NOTE: You might want to remove this if timoni is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	list_github_tags
}

download_release() {
	local version filename platform arch url
	platform="$(get_platform)"
	arch="$(get_arch)"
	version="$1"
	filename="$2"

	url="$GH_REPO/releases/download/v${version}/${TOOL_NAME}_${version}_${platform}_${arch}.tar.gz"
	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

download_checksum() {
  local version="$1"
  local filename="$2"
  local url="$GH_REPO/releases/download/v${version}/${TOOL_NAME}_${version}_checksums.txt"

  echo "* Downloading $TOOL_NAME release $version checksums..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

verify_checksum() {
  local checksums_filename="$1"
  (
    cd "$(dirname "$checksums_filename")"
    shasum -a 256 --check --ignore-missing --strict "$checksums_filename"
  )
}


install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		# TODO: Assert timoni executable exists.
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}

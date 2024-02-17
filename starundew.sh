#! /usr/bin/env bash

dry_run=1
save_dir=$(ls -d "$HOME/.config/StardewValley/Saves/"Enchanted_* | head -n1)
save_file_name=$(basename "${save_dir}")

function backup() {
    local dir=$1

    cd $(dirname "${dir}")
    dir=$(basename "${dir}")
    tar -czf "${dir}_$(date '+%Y-%m-%d_%H%M').bak.tar.gz" "${dir}"
    cd -
}

function file_exists_or_die() {
    local file=$1
    if [[ ! -f "${save_dir}/${file}" ]]; then
        echo "File does not exist: ${save_dir}/${file}":
        exit
    fi
}

function replace() {
    local file=$1

    file_exists_or_die "${file}"
    file_exists_or_die "${file}_old"

	if [ $dry_run -eq 1 ]; then
		echo "[dry-run] Would have invoked:"
		echo "mv \"${save_dir}/${file}_old\" \"${save_dir}/${file}\""
		echo "[dry-run] To execute for real, run: starundew.sh --dry-run=false"
	else
		mv "${save_dir}/${file}_old" "${save_dir}/${file}"
		echo "Replaced file: ${save_dir}/${file} with old file: ${save_dir}/${file}_old"
	fi
}   

if [ "${1}" == '--dry-run=false' ]; then
    dry_run=0
fi

backup $save_dir
replace "${save_file_name}"
replace "SaveGameInfo"


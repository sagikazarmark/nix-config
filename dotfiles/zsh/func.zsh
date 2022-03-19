# Composer in a container
# composer () {
#     tty=
#     tty -s && tty=--tty
#     docker run \
#         $tty \
#         --interactive \
#         --rm \
#         --user $(id -u):$(id -g) \
#         --env COMPOSER_HOME \
#         --env COMPOSER_CACHE_DIR \
#         --volume ${COMPOSER_HOME:-$HOME/.config/composer}:$COMPOSER_HOME \
#         --volume ${COMPOSER_CACHE_DIR:-$HOME/.cache/composer}:$COMPOSER_CACHE_DIR \
#         --volume /private/etc/passwd:/etc/passwd:ro \
#         --volume /private/etc/group:/etc/group:ro \
#         --volume $(pwd):/app \
#         composer "$@"
# }

# Find non ASCI characters in a file
nonasci() {
	grep --color='auto' -P -n '[^\x00-\x7F]' $1
}

# Remove a host from SSH
rmhost() {
	[ $# -eq 0 ] && { echo "Usage: rmhost HOSTNAME"; return 1; }

	ips=$(host "$1" | awk -F'address' '{ print $2}' | sed -e 's/^ //g')
	ssh-keygen -R "$1"

	for ip in $ips; do
		ssh-keygen -R "$ip"
	done
}

# Kill all the processes matching a name
killproc() {
	[ $# -eq 0 ] && { echo "Usage: killproc PROCESSNAME"; return 1; }

	PROCESSES=($(ps aux | grep $1 | awk '{print $2}'))

	for proc in $PROCESSES; do
		kill -9 $proc
	done
}

# Make regular file out of a symlink
removelink() {
	if [ -L $1 ]; then
		temp="$(readlink "$1")";
		rm -rf "$1";
		cp -rf "$temp" "$1";
	fi
}

# Check which process listens on a certain port
wholistens() {
	lsof -n -i4TCP:$1 | grep LISTEN
}

gcloudconf() {
    GCLOUD_CONFIG=${GCLOUD_CONFIG:-$HOME/.gcloudrc}

    typeset -A configs
    while read -r line; do
        arr=(${(s,:,)line})
        key=${arr[1]}
        # join the rest, in case the path contains colons
        val=${(j,:,)arr[2,-1]}

        configs[$key]=$val
    done < $GCLOUD_CONFIG

    config=$1
    if [[ -z $config ]]; then
        config=`print -l ${(k)configs} | fzf`

        if [[ -z $config ]]; then
            echo "error: you did not choose any of the options"
            return 1
        fi
    fi

    if [[ ${configs[$config]} == "" ]]; then
        echo "error: invalid configuration"
        return 1
    fi

    if [[ $config == "default" ]]; then
        unset CLOUDSDK_CONFIG
        unset KUBECONFIG
    else
        export CLOUDSDK_CONFIG=${configs[$config]/#\~/$HOME}
        mkdir -p $HOME/.kube/configs/$config
        export KUBECONFIG=$HOME/.kube/configs/$config/config
    fi

    echo "switched to configuration: $config"
}

regpg() {
    kill -9 `pidof scdaemon` && kill -9 `pidof gpg-agent`
}

## credits to https://gist.github.com/jgrodziski/9ed4a17709baad10dbcd4530b60dfcbb

function dcr-fn {
	docker compose run "$@"
}

function dex-fn {
	docker container exec -it "$1" "${2:-bash}"
}

function drun-fn {
	docker container run -it "$1" "$2"
}

function dnames-fn {
	for ID in $(docker ps | awk '{print $1}' | grep -v 'CONTAINER')
	do
    	docker inspect $ID | grep Name | head -1 | awk '{print $2}' | sed 's/,//g' | sed 's%/%%g' | sed 's/"//g'
	done
}

function dl-fn {
	docker container logs -f "$1"
}

function dsr-fn {
	docker container stop "$1" && docker container rm "$1"
}

function dprune-fn {
       docker container prune --filter "status=exited" -f
}

function drmid-fn {
       imgs=$(docker images -q -f dangling=true)
       [ -n "$imgs" ] && docker image rm "$imgs" || echo "no dangling images."
}

# in order to do things like dex $(dlab label) sh
function dlab {
       docker container ls --filter="label=$1" --format="{{.ID}}"
}

dc() { docker compose "$*";}
d() { docker "$*";}
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dim="docker images"
alias dl="docker container ls"
alias dla="docker container ls --all"
alias dsp="docker system prune --all"

# stop then remove <container>
alias dsr=dsr-fn

# docker compose and run
alias dcr=dcr-fn

# execute a bash shell inside the RUNNING <container>
alias dex=dex-fn

# log the container
alias dlog=dl-fn

# names of all running containers
alias drnames=dnames-fn

# remove all exited containers
alias dprune=dprune-fn

# remove all dangling images
alias drmdi=drmid-fn

# execute a bash shell in NEW container from <image>
alias drun=drun-fn
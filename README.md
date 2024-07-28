# github-webhook-to-workflow-dispatch
This project turns github webhooks into workflow dispatches.

This is useful when you want to react to changes in another repository
without doing it from a workflow.

## Building
This project uses Nix flakes. The default output is a standalone
program. The `container` output builds a Docker container.

```
nix build .
```
or
```
nix build .#container
docker load <result
```

## Running
This tool requires a couple of environment variables to be set. see
the .env file in this repository, and modify to your liking.

Then either
```
set -a
source <your env file>
set +1
nix run .
```
for the standalone, or
```
docker run -p <port>:<port> --env-file <your env file> <whatever docker load spit out>
```

## Running without Nix
Ensure you have SWI-Prolog installed, and have the environment variables in .env set. Then,
```
prolog/github-webhook-to-workflow-dispatch.pl
```

# SaltStack Mom (Master of Masters)


![image](./.gitmedia/mom.jpg)

SaltStack Master of Masters (MoM) inside of Docker.  This is being heaving worked on, so here be dragons!

## Status

Status: Pre-Production

## How it was build

* The docker image `phusion/baseimage` and the tag of `0.9.10`.
* The password to root is `changeme`... CHANGE THIS ASAP!, you have been warned!
* The SSH port is `9001`, to make it live with the host machaine's port 22.
* The Private Keys from SaltStack are stored on the host in `/root/.salt_pki/` via Docker's pass-through.

## How to deploy MOM

### Clone down

```bash
git clone https://github.com/jasonswindle/mom
```
### Change directory into project

```bash
cd mom/
```

### Build MOM

```bash
docker build --rm --tag='mom' .
```

### Run MOM

```bash
docker run \
    --interactive=true \
    --tty=true \
    --volume=/root/.salt_pki:/etc/salt/pki:rw \
    --volume=/opt/tools:/usr/bin/tools:ro \
    --volume=/srv:/srv:ro \
    --publish=4505:4505 \
    --publish=4506:4506 \
    --publish=9001:9001 \
    --hostname="mom" \
    --detach=true \
    mom:latest
```

## To-Do

* Clean up Dockerfile; more logic less layers.
* Tighten up the RUNIT conf files.
* Fill out the README.md more.
* Test heavly.
* Replace Mom image with image I have he copyright to.
* Check into index.docker.io ?

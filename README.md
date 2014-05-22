# SaltStack Mom (Master of Masters)

![image](./.gitmedia/mom.jpg)

SaltStack Master of Masters (MoM) inside of Docker.  This is being heaving worked on, so here be dragons!

## Status
Status: Pre-Production

## How it was build
* The docker image `phusion/baseimage` and the tag of `0.9.10`.
* The password to root is `changeme`... CHANGE THIS ASAP!, you have been warned!
* The SSH port is `16022`, to make it live with the host machaine's port 22.
* The Private Keys from SaltStack are stored on the host in `/root/.pki/` via Docker's pass-through.

# How to deploy Mom
```bash
git clone https://github.com/JasonSwindle/mom
```

```bash
cd mom/
```

```bash
docker build --rm --tag='mom' .
```

```bash
docker run -it -v /root/.pki:/etc/salt/pki:rw -p 4505:4505 -p 4506:4506 -p 16022:16022 -h mom -d mom:latest
```

or for the people who don't run things with short flags....
```bash
docker run --interactive=true --tty=true --volume=/root/.pki:/etc/salt/pki:rw --publish=4505:4505 --publish=4506:4506 --publish=16022:16022 --hostname="mom" --detach=true mom:latest
```

## To-Do

* Clean up Dockerfile; more logic less layers.
* Tighten up the RUNIT conf files.
* Fill out the README.md more.
* Test heavly.
* Replace Mom image with image I have he copyright to.
* Check into index.docker.io ?

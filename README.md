# mom

![image](./gitmedia/mom.jpg)

SaltStack Master of Masters (MoM) inside of Docker.  This is being heaving worked on, so here be dragons!

Status: Pre-Production

# Deploy

```bash
git clone https://github.com/JasonSwindle/mom
```

```bash
docker build --rm --tag='mom' .
```

```bash
docker run -it -v /root/.pki:/etc/salt/pki:rw -p 4505:4505 -p 4506:4506 -p 16022:16022 -h mom -d mom:latest
```

or for the people who don't run things with short flags....
```bash
docker run --interactive=true --tty=true -v /root/.pki:/etc/salt/pki:rw -p 4505:4505 -p 4506:4506 -p 16022:16022 --hostname="mom" --detach=true mom:latest
```

# To-Do

* Clean up Dockerfile
* Tighten up the RUNIT  conf files
* Fill out the README.md more

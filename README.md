> [!WARNING]
> **ARCHIVED REPOSITORY**
>
> This project is deprecated, and this repository is available only for
> archiving purposes. I am also no longer maintaining the associated Docker
> image, which is probably wildly outdated by now.

# Quick reference

* **Maintained by:** [taskbjorn](https://github.com/taskbjorn)

* **Where to get help:** [GitHub](https://github.com/taskbjorn/docker-dstds/issues)

# Supported tags and respective Dockerfile links

* [**docker-dstds**](https://github.com/taskbjorn/docker-dstds/blob/main/build)
  * [`latest`, `464835`](https://github.com/taskbjorn/docker-dstds/blob/main/build/latest)

# What is `docker-dstds`?

`docker-dstds` is a Docker container for the Don't Starve Together Linux
dedicated server.

![docker-dstds logo](https://github.com/taskbjorn/docker-dstds/blob/main/docker-dstds.png)

The container is based on a minimal Debian image running SteamCMD.

# How to use this image

# Basic setup using Docker Compose

* Clone the git repository in a new folder:

  ```bash
  git clone https://github.com/taskbjorn/docker-dstds
  ```

* Substitute `<insert-your-server-token-here>` under `compose/env/dst.env` with
  the server token obtained from your Klei account.

* Run the server startup script:

  ```bash
  cd compose
  bash Allrun.sh
  ```

## Running additional shards

By default, the Compose project initialises two servers, the master server
running Overworld and a shard server running a Caves world. To run additional
shards, add the following lines to the services in your docker-compose.yml file:

```yml
  dst-newshard:
    container_name: dst-newshard
    environment:
      - "SHARD_NAME=NewShard"
    image: taskbjorn/dst-dockerised:latest
    networks:
      - backend
    restart: unless-stopped
    volumes:
      - "data:/home/dst/.klei/DoNotStarveTogether/MyDediServer"
```

Then, clone the master server configuration

```bash
cd compose/MyDediServer
cp -R Master NewShard
```

Edit `NewShard/server.ini` by increasing `server_port`, `master_server_port` and
`authentication_port` by one digit and setting `is_master` to `false`. Also edit
`NewShard/worldgenoverrides.lua` according to your world generation preferences.

# Caveats

By default, the Compose project uses Docker volumes to store your server data
(as in the example files provided in the repository), you must run the server
using `bash compose/Allrun.sh`. The script will copy the default configuration
files for the Overworld + Caves servers into the Docker volume and set file
ownership accordingly. If you would like to change server configuration or setup
additional shards, you must now do so from the `compose/MyDediServer` directory,
as these files will be copied inside the Docker volume automatically at each
container run.

Alternatively, one may skip Docker volumes and use a simple mountpoint. To do
so, remove all volume definitions from `compose/docker-compose.yml` and edit the
volume mountpoints for each service as shown below:

```yml
(...)
    volumes:
      - "./MyDediServer:/home/dst/.klei/DoNotStarveTogether/MyDediServer"
(...)
```

# License

This image is licensed under [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html).

As it is often the case with Docker images, some of the software contained in
this image (e.g. the base image, software included in the base image, etc.) may
be covered under a difference license.

Please remember it is your responsibility as the end-user to ensure that your
use case complies with the licenses of all included software.
# Mbed Tools Docker

This is an un-official [mbed-tools](https://os.mbed.com/docs/mbed-os/v6.12/build-tools/mbed-cli-2.html) docker image. 

Currently it only supports `GCC Arm` as its default compiler.

For old mbed-cli docker image see [https://github.com/jakhax/docker-mbed-cli](https://github.com/jakhax/docker-mbed-cli)


## Building
```bash
docker build -t "mbed_tools" --build-arg USER_ID=$(id -u)  --build-arg GROUP_ID=$(id -g) .
```

if you dont plan on using it with your default user(shared user permissions) you can edit this part out in the Dockerfile
```dockerfile
#shared user permissions
ARG USER_ID
ARG GROUP_ID
RUN addgroup --gid $GROUP_ID user
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user
USER user
```
then build using
```bash
docker build -t "mbed_tools" .
```

You can  add an alias like `mbed_tools` to use it like `mbed-tools`
```bash
alias mbed_docker='docker run -it -v $(pwd):/home/projects:cached mbed_tools mbed-tools'
```

## Usage

**Using above alias**
```bash
╰─$ mbed_tools
Usage: mbed-tools [OPTIONS] COMMAND [ARGS]...

  Command line tool for interacting with Mbed OS.

...
```

**Without alias**
```bash
╰─$ docker run -it -v $(pwd):/home/projects:cached mbed_tools Usage: mbed-tools [OPTIONS] COMMAND [ARGS]...

  Command line tool for interacting with Mbed OS.
...
```

## Todo
- [ ] Reduce image size using alpine base image or multistage image.

## Resources

- https://os.mbed.com/docs/mbed-os/v6.12/build-tools/install-or-upgrade.html
- https://vsupalov.com/docker-shared-permissions/
- https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads
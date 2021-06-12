#!/bin/sh

# Port to which the task will be exposed
PORT=${1-1337}

IMG_NAME="compile_exec_service"

docker build -t ${IMG_NAME} .

# NOTE:
# The options below passed to docker are generally INSECURE. We use them as we use
# nsjail anyway.
# Docker is used just for easier bootstraping of nsjail, i.e.:
# - to have a non-host chroot (and consistent environment) for jailed processes/tasks
# - to be able to run the service with one command, assuming docker is installed on machine
#
# We need:
# - CHOWN, SETUID, SETGID, AUDIT_WRITE - to use `su -l jailed ...`
# - SYS_ADMIN and CHOWN to prepare (mount) cgrops for nsjail
# - no apparmor and no seccomp to prepare cgroups and to spawn jails
#
docker run \
    -d \
    --name ${IMG_NAME} \
    --restart=always \
    --cap-drop=all \
    --cap-add=CHOWN \
    --cap-add=SETUID \
    --cap-add=SETGID \
    --cap-add=AUDIT_WRITE \
    --cap-add=SYS_ADMIN \
    --cap-add=MKNOD \
    --security-opt apparmor=unconfined \
    --security-opt seccomp=unconfined \
    -p $PORT:1337 \
    ${IMG_NAME}

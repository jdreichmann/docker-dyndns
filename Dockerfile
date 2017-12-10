FROM alpine:edge
MAINTAINER Jona Reichmann https://github.com/jreichmann/

# Set user- and group-ID so it can be overriden from outside
ENV	UID=128 \
	GID=128

# Update and upgrade, and add curl, bash, su-exec, s6 and python3
RUN apk update && \
	apk upgrade && \
	apk add --upgrade \
		curl \
		bash \
		su-exec \
		cron \
		python3

# Enable crond to start automatically
RUN rc-service crond start && rc-update add crond

# Add the tree from the 'dockerFS' folder into the containers filesystem
ADD dockerFS /

# Set execute permissions for the cronjob
RUN chmod a+x /etc/periodic/15min/dyndns_update

# Verify that cron will actually run the update script
RUN run-parts --test /etc/periodic/15min

# Expose the folder with the script, config and ip-store to give external access to the config
VOLUME /opt/DynDNSUpdater

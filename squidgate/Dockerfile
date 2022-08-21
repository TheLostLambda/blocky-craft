FROM alpine:latest
# Generate the package index, update all packages, and install bash + openssh
RUN apk update && apk upgrade && apk add bash openssh

# Create and change to the new forward user
RUN adduser -D forward
USER forward

# Move work to forward's home directory
WORKDIR ~/

# Copy the forward ports script into the container
COPY forward-ports.sh .

# Expose the ssh directory as a volume
VOLUME /home/forward/.ssh

# Port-forward to an SSH remote!
CMD ["./forward-ports.sh"]

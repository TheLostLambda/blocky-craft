FROM alpine:latest
# Generate the package index, update all packages, and install JRE
RUN apk update && apk upgrade && apk add openjdk17-jre-headless

# Move work to root's home directory
WORKDIR /root/

# Pull the Minecraft 1.19.2 Server JAR
RUN wget https://piston-data.mojang.com/v1/objects/f69c284232d7c7580bd89a5a4931c3581eae1378/server.jar

# Copy the server launch script into the container
COPY launch.sh .

# Create and move to a config directory
WORKDIR /root/config

# Expose the config directory as a volume
VOLUME /root/config

# Port-forward and run Minecraft!
EXPOSE 25565
CMD ["../launch.sh"]

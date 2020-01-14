FROM rust:alpine as blocky-build
# Generate the package index and install git
RUN apk update && apk add git musl-dev
# Use nightly rust
RUN rustup default nightly

# Pull the Blocky bot code from Gitlab
WORKDIR /root/
RUN git clone https://gitlab.com/TheLostLambda/blocky.git

# Link dynamically for Alpine
ENV RUSTFLAGS="-C target-feature=-crt-static"

# Build the optimised code
WORKDIR /root/blocky/
RUN cargo build --release


FROM alpine:latest
# Generate the package index and install JRE + libgcc
RUN apk update && apk add openjdk11-jre-headless libgcc

WORKDIR /root/
# Pull the Minecraft 1.15.1 Server JAR
RUN wget https://launcher.mojang.com/v1/objects/4d1826eebac84847c71a77f9349cc22afd0cf0a1/server.jar

# Pull in the Blocky binary
COPY --from=blocky-build /root/blocky/target/release/blocky .

# Setup IPC pipes
RUN mkfifo mci mco

# Create and move to the mountable configuration directory
WORKDIR /root/config
# Pull in the Blocky configuration file
COPY --from=blocky-build /root/blocky/personalities/blocky.toml .
# Pull in the PipeCraft script
COPY --from=blocky-build /root/blocky/scripts/PipeCraft.sh .

# Change the script to launch the applications from the parent directory
RUN sed -i "s server.jar ../server.jar g;s ./blocky ../blocky g;s mci ../mci g;s mco ../mco g" PipeCraft.sh

# Agree to the EULA
RUN echo "eula=true" > eula.txt

# Expose the configuration directory as a volume
VOLUME /root/config

# Port-forward and run Minecraft!
EXPOSE 25565
CMD ["./PipeCraft.sh"]

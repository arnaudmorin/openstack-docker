FROM debian:bookworm

# Install some deps
RUN apt-get update && apt-get install -y python3-venv nginx gettext-base libnginx-mod-http-lua vim procps wget

# Build openstack client
RUN python3 -m venv /opt/oscli
RUN /opt/oscli/bin/pip install python-openstackclient

# Set some vars
ENV CF_PORT=80 \
    CF_SERVER_NAME=localhost \
    CF_MISTRAL_URL=http://127.0.0.1:8989

# Copy some files
COPY data/auth.lua /etc/nginx/auth.lua
COPY data/nginx-template /tmp/nginx-template
COPY data/cloudflow-get-token /bin/cloudflow-get-token
RUN chmod +x /bin/cloudflow-get-token

# Get cloudflow code
RUN wget -O /opt/cf.tar.gz https://github.com/arnaudmorin/CloudFlow/releases/download/0.7.0/CloudFlow.tar.gz
RUN cd /opt && tar -xzvf /opt/cf.tar.gz

# Configure nginx
RUN echo 'daemon off;' > /etc/nginx/modules-enabled/no-daemon.conf
RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stdout /var/log/nginx/error.log

EXPOSE $CF_PORT
CMD envsubst '$$CF_PORT $$CF_SERVER_NAME $$CF_MISTRAL_URL' < /tmp/nginx-template > /etc/nginx/sites-enabled/default && nginx

FROM ghcr.io/igastorm/vdide:latest@sha256:f668f8fe4f97b8108ccbba49f42a47be64f8c7224eb90118091a27942fff8f6b

RUN rm -f /var/log /run && \
  mkdir -p /var/log/apt /run && \
  echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/99-no-languages && \
  echo 'Acquire::Languages::Target "en";' >> /etc/apt/apt.conf.d/99-no-languages && \
  apt-get update && apt-get install -y --no-install-recommends \
  nasm && \
  apt-get clean && \
  find /usr/share/locale -mindepth 1 -maxdepth 1 ! -name 'en*' ! -name 'locale.alias' -exec rm -rf {} + && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/* && \
  rm -rf /var/log /run && \
  ln -s /tmp/log /var/log && \
  ln -s /tmp/run /run

RUN sed -i 's|--disable-workspace-trust|--disable-workspace-trust /home/\$USER_NAME/x86emu|' /usr/local/etc/supervisord-template.conf && \
echo '#!/bin/bash\n\
set -e\n\
REPO_URL="https://github.com/igastorm/x86emu.git"\n\
TARGET_DIR="/home/$USER_NAME/x86emu"\n\
\n\
if [ ! -d "$TARGET_DIR" ]; then\n\
    sudo -u "$USER_NAME" git clone "$REPO_URL" "$TARGET_DIR"\n\
fi\n\
' > /usr/local/bin/custom-setup.sh && \
    chmod +x /usr/local/bin/custom-setup.sh

FROM ghcr.io/igastorm/vdide:latest@sha256:fca3dd3c7972d3f5f4d8ff9eb47a90a6e457088e1b8fd7bc2711462d0f71bf6f

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

RUN echo '#!/bin/bash\n\
set -e\n\
REPO_URL="https://github.com/igastorm/x86emu.git"\n\
TARGET_DIR="/home/$USER_NAME/x86emu"\n\
\n\
if [ ! -d "$TARGET_DIR" ]; then\n\
    sudo -u "$USER_NAME" git clone "$REPO_URL" "$TARGET_DIR"\n\
fi\n\
' > /usr/local/bin/custom-setup.sh && \
    chmod +x /usr/local/bin/custom-setup.sh

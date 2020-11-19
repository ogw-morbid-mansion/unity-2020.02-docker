FROM archlinux:latest

RUN pacman -Syu --noconfirm && \
  pacman -S --needed --noconfirm nano curl git base-devel xorg-server-xvfb unzip gtk3

# Install yay
RUN git clone https://aur.archlinux.org/yay.git && \
  cd yay && \
  sed -i.bak 's/exit $E_ROOT//' /usr/bin/makepkg && \
  makepkg -si --noconfirm && \
  cd .. && \
  rm -rf yay

# Download Unity
RUN curl -LJ https://beta.unity3d.com/download/c499c2bf2e80/UnitySetup-2020.2.0b11 -o UnitySetup && \
  chmod +x UnitySetup && \
  echo y | \
  # install unity with required components
  (xvfb-run --auto-servernum --server-args='-screen 0 640x480x24' \
  ./UnitySetup \
  --unattended \
  --install-location=/opt/Unity \
  --verbose \
  --download-location=/tmp/unity \
  --components=Unity,Linux-IL2CPP || true) && \
  tar -xvf /tmp/unity/Unity.tar.xz -C /opt/Unity && \
  tar -xvf /tmp/unity/UnitySetup-Linux-IL2CPP-Support-for-Editor-2020.2.0b11.tar.xz -C /opt/Unity && \
  rm UnitySetup && \
  rm -rf /tmp/unity

ADD scripts/* /usr/bin/

CMD [ "/bin/bash" ]

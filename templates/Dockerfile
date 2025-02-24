FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    build-essential cmake ninja-build git wget unzip python3 python3-pip openjdk-11-jdk \
    libgl1-mesa-dev libglib2.0-dev libpulse-dev libxcb1-dev libxcb-glx0-dev libxcb-icccm4-dev \
    libxcb-image0-dev libxcb-keysyms1-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev \
    libxcb-shape0-dev libxcb-shm0-dev libxcb-sync-dev libxcb-util-dev libxcb-xfixes0-dev \
    libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev libfontconfig1-dev \
    libfreetype6-dev libx11-dev libx11-xcb-dev libxext-dev libxfixes-dev libxi-dev libxrender-dev \
    libxcb-cursor-dev && rm -rf /var/lib/apt/lists/*

ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=${ANDROID_HOME}
ENV PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip && \
    unzip commandlinetools-linux-*_latest.zip && mv cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest && \
    rm commandlinetools-linux-*_latest.zip
RUN yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --licenses && \
    ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0" "ndk;25.1.8937393"

ENV QT_VERSION=6.3.2
ENV QT_DIR=/opt/qt
RUN pip3 install aqtinstall
RUN aqt install-qt linux desktop ${QT_VERSION} gcc_64 --outputdir ${QT_DIR} && \
    aqt install-qt linux android ${QT_VERSION} android_arm64_v8a --outputdir ${QT_DIR} --modules qtwebview qtquick3d qtquicktimeline qtremoteobjects qtserialport qtshadertools && \
    aqt install-qt linux android ${QT_VERSION} android_armv7 --outputdir ${QT_DIR} --modules qtwebview qtquick3d qtquicktimeline qtremoteobjects qtserialport qtshadertools

ENV PATH=${PATH}:${QT_DIR}/${QT_VERSION}/gcc_64/bin
ENV QT_HOST_PATH=${QT_DIR}/${QT_VERSION}/gcc_64
ENV ANDROID_NDK_ROOT=${ANDROID_HOME}/ndk/25.1.8937393
ENV ANDROID_SDK_ROOT=${ANDROID_HOME}

WORKDIR /src
COPY . /src

RUN chmod +x build.sh
CMD ["bash", "-c", "./build.sh /src 2>&1 | tee /src/build.log"]
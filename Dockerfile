FROM ubuntu:21.04

#Prerequisites
RUN apt-get update && apt-get install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget

# set up new user
RUN useradd -ms /bin/bash larrick
USER larrick
WORKDIR /home/larrick

#Prepare  Android directories and system variables
RUN mkdir -p Android/sdk
ENV ANDROID_SDK_ROOT /home/larrick/Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg

#set up Android sdk
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv tools Android/sdk/tools
RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses
RUN cd Android/sdk/tools/bin && ./sdkmanager "build-tools;30.0.3" "patcher;v4" "platform-tools" "platforms;android-30" "sources;android-30"
ENV PATH "$PATH:/home/larrick/Android/sdk/platform-tools"

#Download flutter sdk
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/larrick/flutter/bin"

RUN flutter doctor
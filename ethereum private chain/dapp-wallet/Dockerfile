FROM ubuntu:16.04
RUN apt-get update && apt-get -y install curl locales
ENV OS_LOCALE="en_US.UTF-8"
RUN locale-gen ${OS_LOCALE}
ENV LANG=${OS_LOCALE} \
LANGUAGE=en_US:en \
LC_ALL=${OS_LOCALE}
RUN curl https://install.meteor.com/ | sh

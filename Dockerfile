FROM quay.io/ukhomeofficedigital/centos-base



RUN rpm --rebuilddb && \
  yum install -y  \
      git \
      curl \
      which \
      nginx \
      gcc-c++ \
      bzip2 \
      xorg-x11-server-Xvfb\
      java

RUN curl -kl https://www.quovadisglobal.bm/Repository/~/media/Files/Roots/quovadis_qvsslg2_der.ashx > /etc/pki/ca-trust/source/anchors/quovadisglobal
RUN update-ca-trust force-enable

RUN mkdir -p /opt/nodejs
WORKDIR /opt/nodejs
RUN curl https://nodejs.org/dist/v4.2.2/node-v4.2.2-linux-x64.tar.gz | tar xz --strip-components=1
ENV PATH=${PATH}:/opt/nodejs/bin
RUN npm install -g phantomjs-prebuilt

WORKDIR /home/app

ADD nightwatch/package.json package.json
RUN npm install
COPY nightwatch/. .


CMD xvfb-run --server-args="-screen 0, 1024x768x24" & npm test
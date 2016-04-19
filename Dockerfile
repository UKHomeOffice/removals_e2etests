FROM quay.io/ukhomeofficedigital/centos-base

RUN printf "[google64]\nname=Google - x86_64\nbaseurl=http://dl.google.com/linux/rpm/stable/x86_64\n\enabled=1\ngpgcheck=1\ngpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub" > /etc/yum.repos.d/google-chrome.repo

RUN rpm --rebuilddb \
  && yum install -y  \
      git \
      curl \
      which \
      nginx \
      gcc-c++ \
      bzip2 \
      Xvfb \
      firefox \
      google-chrome-stable \
      java-1.8.0-openjdk \
  && yum clean all

RUN curl -kl https://www.quovadisglobal.bm/Repository/~/media/Files/Roots/quovadis_qvsslg2_der.ashx > /etc/pki/ca-trust/source/anchors/quovadisglobal \
    && update-ca-trust force-enable

RUN mkdir -p /opt/nodejs
WORKDIR /opt/nodejs
RUN curl https://nodejs.org/dist/v4.2.2/node-v4.2.2-linux-x64.tar.gz | tar xz --strip-components=1
ENV PATH=${PATH}:/opt/nodejs/bin:/home/app/node_modules/.bin

WORKDIR /home/app

ADD nightwatch/package.json package.json
RUN npm install
COPY nightwatch/. .

CMD xvfb-run --server-args="-screen 0, 1024x768x24" npm test
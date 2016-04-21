FROM quay.io/ukhomeofficedigital/centos-base

RUN rpm --rebuilddb \
  && yum install -y  \
      git \
      curl \
      which \
      bzip2 \
  && yum clean all

#RUN curl -kl https://www.quovadisglobal.bm/Repository/~/media/Files/Roots/quovadis_qvsslg2_der.ashx > /etc/pki/ca-trust/source/anchors/quovadisglobal \
#    && update-ca-trust force-enable

RUN mkdir -p /opt/nodejs
WORKDIR /opt/nodejs
RUN curl https://nodejs.org/dist/v4.2.2/node-v4.2.2-linux-x64.tar.gz | tar xz --strip-components=1
ENV PATH=${PATH}:/opt/nodejs/bin:/home/app/node_modules/.bin

WORKDIR /home/app

ADD nightwatch/package.json package.json
RUN npm install
COPY nightwatch/. .

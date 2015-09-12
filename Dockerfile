FROM alpine:latest

RUN apk --update add build-base ca-certificates ruby-dev \
     && rm -rf /var/cache/apk/*

RUN echo 'gem: --no-document' >> /etc/gemrc
RUN gem install fluentd -v 0.12.15

RUN mkdir -p /fluentd/log
RUN mkdir -p /fluentd/etc
RUN mkdir -p /fluentd/plugins

COPY fluent.conf /fluentd/etc/
ONBUILD COPY fluent.conf /fluentd/etc/
ONBUILD COPY plugins/* /fluentd/plugins/

ENV FLUENTD_OPT=""
ENV FLUENTD_CONF="fluent.conf"

EXPOSE 24224

### docker run -d --name fluentd -p 24224 -v `pwd`/log:/fluentd/log philipz/fluentd:latest
CMD fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT

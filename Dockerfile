FROM alpine:latest

RUN apk --update add build-base ca-certificates ruby-dev \
     && rm -rf /var/cache/apk/*

RUN echo 'gem: --no-document' >> /etc/gemrc
RUN gem install fluentd -v 0.12.11

RUN mkdir -p /fluentd
RUN mkdir -p /fluentd/etc
RUN mkdir -p /fluentd/plugins

COPY fluent.conf /fluentd/etc/
ONBUILD COPY fluent.conf /fluentd/etc/
ONBUILD COPY plugins/* /fluentd/plugins/

ENV FLUENTD_OPT=""
ENV FLUENTD_CONF="fluent.conf"

EXPOSE 24224

CMD fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT

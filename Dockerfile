# Ubuntu 18.04 기반 이미지 사용
FROM ubuntu:bionic

# 비대화형 모드 설정
ENV DEBIAN_FRONTEND=noninteractive

# APT 소스 업데이트
RUN apt-get update && apt-get install -y && \
    apt-get update

RUN apt-get install -y \
    hylafax-server \
    supervisor \
    t38modem

# Supervisor 설정 복사
COPY ./supervisord.conf /etc/supervisor/supervisord.conf
COPY ./init-hylafax.sh /usr/sbin/hylafax-init.sh

ENV SIPADDR=sip.example.com
ENV SIPUSER=user
ENV SIPPASS=password

# 팩스 자동전송 스크립트 설정
COPY ./faxsend.sh /usr/bin/faxsend.sh
COPY ./faxsend.cron /usr/bin/cron-faxsend.sh
RUN chmod a+x /usr/bin/faxsend.sh && chmod a+x /usr/bin/cron-faxsend.sh
RUN touch /var/log/faxsend.log

# Supervisor 실행 설정
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

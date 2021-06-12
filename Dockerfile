FROM disconnect3d/nsjail:2.9

RUN apt-get update && apt-get install -y \
 gcc python3

RUN groupadd -g 1000 service && \
    useradd --uid 1000 --gid 1000 service && \
    mkdir /home/service && \
    chown service /home/service -R && \
    chmod 755 /home/service -R

ADD ./runner /home/service/
ADD ./nsjail.cfg /nsjail.cfg
ADD ./run_service.sh /run_service.sh

CMD /run_service.sh

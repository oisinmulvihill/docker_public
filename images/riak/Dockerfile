# http://stackoverflow.com/questions/17252356/run-a-service-automatically-in-a-docker-container
FROM ubuntu
RUN apt-get update
RUN apt-get install -y openssh-server curl
RUN curl http://apt.basho.com/gpg/basho.apt.key | apt-key add -
RUN bash -c "echo deb http://apt.basho.com precise main > /etc/apt/sources.list.d/basho.list"
RUN apt-get update
RUN apt-get -y install riak
RUN perl -p -i -e 's/(?<=\{http,\s\[\s\{")127\.0\.0\.1/0.0.0.0/g' /etc/riak/app.config
EXPOSE 8098
CMD /bin/riak start && tail -F /var/log/riak/erlang.log.1

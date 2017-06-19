FROM python:2.7
MAINTAINER Prashanth Madi<prashanthrmadi@gmail.com>

ENV AIRFLOW_HOME /airflow

RUN apt-get update \
	&& apt-get install -y libpcre3-dev build-essential \
	&& apt-get install --no-install-recommends --no-install-suggests -y \
						supervisor \
	            		openssh-server \
	&& echo "root:Docker!" | chpasswd

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf	
COPY sshd_config /etc/ssh/
COPY init_container.sh /bin/
COPY requirements.txt /bin/

RUN chmod 755 /bin/init_container.sh
  
# Install app dependent modules
RUN pip install -r /bin/requirements.txt

# initialize the database
RUN airflow initdb

EXPOSE 80 2222

CMD ["/bin/init_container.sh"]

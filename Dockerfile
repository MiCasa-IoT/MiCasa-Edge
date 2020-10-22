FROM python:3.9.0-buster as build-stage

WORKDIR /opt/app

COPY requirements.lock /opt/app

RUN apt-get update \
&& apt-get install unixodbc -y \
unixodbc-dev \
tdsodbc \
&& apt-get install --reinstall build-essential -y \
&& apt-get install python-dateutil -y \
&& apt-get -y clean
RUN pip3 install -r /opt/app/requirements.lock

FROM python:3.9.0-slim-buster

WORKDIR /opt/app

COPY --from=build-stage /root/.cache/pip /opt/app/.cache/pip
COPY --from=build-stage /opt/app/requirements.lock /opt/app

COPY --from=build-stage /usr/lib/x86_64-linux-gnu/libodbc.so.2 /usr/lib/x86_64-linux-gnu/
COPY --from=build-stage /usr/lib/x86_64-linux-gnu/libodbcinst.so.2 /usr/lib/x86_64-linux-gnu/
COPY --from=build-stage /usr/lib/x86_64-linux-gnu/libkrb5.so.3 /usr/lib/x86_64-linux-gnu/
COPY --from=build-stage /usr/lib/x86_64-linux-gnu/libgssapi_krb5.so.2 /usr/lib/x86_64-linux-gnu/
COPY --from=build-stage /usr/lib/x86_64-linux-gnu/libltdl.so.7 /usr/lib/x86_64-linux-gnu/
COPY --from=build-stage /usr/lib/x86_64-linux-gnu/libk5crypto.so.3 /usr/lib/x86_64-linux-gnu/
COPY --from=build-stage /usr/lib/x86_64-linux-gnu/libkrb5support.so.0 /usr/lib/x86_64-linux-gnu/
COPY --from=build-stage /lib/x86_64-linux-gnu/libkeyutils.so.1 /lib/x86_64-linux-gnu/
COPY --from=build-stage /usr/lib/x86_64-linux-gnu/libk5crypto.so.3 /usr/lib/x86_64-linux-gnu/
COPY --from=build-stage /usr/lib/x86_64-linux-gnu/libkrb5support.so.0 /usr/lib/x86_64-linux-gnu/
COPY --from=build-stage /lib/x86_64-linux-gnu/libkeyutils.so.1 /lib/x86_64-linux-gnu/

RUN apt-get update \
&& apt-get install unixodbc -y \
unixodbc-dev \
tdsodbc \
python-dateutil \
bluez \
libbluetooth-dev \
&& apt-get -y clean \
&& apt-get -y autoremove

RUN pip3 install -r /opt/app/requirements.lock \
&& rm -rf /opt/app/.cache/pip

COPY . .
#CMD ['python', '/opt/app/main.py']

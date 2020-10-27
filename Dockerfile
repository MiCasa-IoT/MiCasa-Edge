FROM balenalib/raspberrypi4-64-python:3.8.5-buster-run

WORKDIR /usr/src/app

ENV UDEV=1

RUN install_packages unixodbc \
unixodbc-dev \
tdsodbc \
python3-dateutil \
bluez \
libbluetooth-dev \
gcc

COPY requirements.lock requirements.lock
RUN pip install -r requirements.lock

COPY . ./

CMD ["python","-u","src/main.py"]

FROM --platform=arm64 python:3.12-slim

COPY . /app
WORKDIR /app

RUN pip3 install -r requirements.txt

EXPOSE 80

CMD [ "python3", "app.py"]
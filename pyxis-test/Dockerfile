FROM python:3.11-slim-buster

WORKDIR /pyxis-test

COPY requirements.txt requirements.txt

RUN pip3 install -r requirements.txt
RUN mkdir static templates
COPY . .

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]

FROM python:3.9.12-buster

WORKDIR /usr/src/app/

COPY requirements.txt /usr/src/app/
COPY api.py /usr/src/app/
COPY log_conf.yml /usr/src/app/

RUN pip install --no-cache-dir --upgrade -r /usr/src/app/requirements.txt

EXPOSE 8082

ENV AWS_DEFAULT_REGION=us-east-1

CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8082", "--log-config", "log_conf.yml"]
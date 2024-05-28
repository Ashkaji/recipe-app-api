FROM python:3.12-alpine3.20
LABEL maintainer="londonappdeveloper.com"

ENV PYTHONUNBUFFERED 1

ARG DEV=false
ENV DEV=${DEV}

COPY ./requirements.txt ./tmp/requirements.txt
COPY ./requirements.dev.txt ./tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

RUN python -m venv /py && \
  /py/bin/pip install --upgrade pip && \
  /py/bin/pip --default-timeout=100 install -r /tmp/requirements.txt && \
  if [ "$DEV" = "true" ]; then /py/bin/pip --default-timeout=100 install -r /tmp/requirements.dev.txt; fi && \
  rm -rf /tmp && \
  adduser -D -H django-user

ENV PATH="/py/bin:$PATH"

USER django-user

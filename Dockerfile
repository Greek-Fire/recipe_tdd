FROM python:3.9
LABEL maintainer="Hallas, l.l.c"

ENV PYTHONUNBUFFERED 1
# Allows instant viewing of logs

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000


# Create a virtual environment and install dependencies
# virtualenv is a tool to create isolated Python environments
# allows consistent installation of packages, incase the base python image changes
RUN DEV=false
# docker-compose will set the DEV to true for developement
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ] ; then \
        pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp/* && \
    adduser \
    --disabled-password \
    --no-create-home \
    django-user

ENV PATH="/py/bin:${PATH}"

USER django-user
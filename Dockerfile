FROM python:3.9
LABEL maintainer="Hallas, l.l.c"

ENV PYTHONUNBUFFERED 1
# Allows instant viewing of logs

EXPOSE 8000
ARG DEV=false
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY /var/home/core/recipe_tdd/app /home/django/app

# Create a virtual environment and install dependencies
# virtualenv is a tool to create isolated Python environments
# allows consistent installation of packages, incase the base python image changes
# docker-compose will set the DEV to true for developement
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = true ] ; then \
        pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp/* && \
    addgroup django && \
    useradd \
    --password  ""\
    -g django \
    django && \
    chown -R django:django /home/django

ENV PATH="/py/bin:${PATH}"

USER django
WORKDIR /home/django/app
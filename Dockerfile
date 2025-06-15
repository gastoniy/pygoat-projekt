FROM python:3.11-bookworm


# set work directory
WORKDIR /app


# dependencies for psycopg2
RUN apt-get update && apt-get install --no-install-recommends -y bind9-dnsutils libpq-dev libpython3-dev && apt-get clean && rm -rf /var/lib/apt/lists/*


# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1


# Install dependencies
RUN python -m pip install pip==22.0.4
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt


# copy project
COPY . /app/


# install pygoat
EXPOSE 8000


RUN python3 /app/manage.py migrate
WORKDIR /app
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers","6", "pygoat.wsgi"]

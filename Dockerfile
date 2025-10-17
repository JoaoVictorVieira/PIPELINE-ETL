FROM python:3.10-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-17-jre-headless \
    build-essential \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Download PostgreSQL JDBC driver
RUN wget -O /tmp/postgresql-42.7.1.jar https://jdbc.postgresql.org/download/postgresql-42.7.1.jar

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8888

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=", "--NotebookApp.password="]


FROM python:3.11.0
EXPOSE 5000
COPY requirements.txt .
RUN python -m pip install -r requirements.txt
WORKDIR /app
COPY . /app
ENV PROMETHEUS_MULTIPROC_DIR=/tmp/metrics
RUN mkdir -p /tmp/metrics
RUN chmod +x /app/entrypoint.sh
CMD ["/app/entrypoint.sh"]

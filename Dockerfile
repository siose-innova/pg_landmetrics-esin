FROM siose-innova/eco:base

# Dependencies:
# 1 install build dependencies from Alpine packages
# 2 install pg_landmetrics extension from sources
# 3 remove build dependencies
WORKDIR /usr/local/src
RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
        git \
        make \
    && git clone https://github.com/siose-innova/pg_landmetrics.git \
    && cd pg_landmetrics \
    && make \
    && make install \
    && cd .. \
    && rm -rf pg_landmetrics \
    && apk del .build-deps \
    && cd

# Modify postgresql.conf in order to save
# EXPLAIN ANALYZE output using
# auto_explain module
VOLUME /var/lib/postgresql/data/log
CMD ["postgres", \
     "-c", \
     "logging_collector=on", \
     "-c", \
     "log_directory=/var/lib/postgresql/data/log", \
     "-c", \
     "log_destination=csvlog", \
     "-c", \
     "log_rotation_size=0", \
     "-c", \
     "shared_preload_libraries=auto_explain", \
     "-c", \
     "auto_explain.log_min_duration=100", \
     "-c", \
     "auto_explain.log_analyze=on", \
     "-c", \
     "auto_explain.log_timing=off", \
     "-c", \
     "auto_explain.log_format=json"]


WORKDIR /usr/local/bin

# Set environment variables
ENV ECO_DB eco

# Copy Bash script
COPY setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

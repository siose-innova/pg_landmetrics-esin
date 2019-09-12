FROM siose-innova/mf2:2014

# Dependencies:
# 1 install build dependencies from Alpine packages
# 2 install pg_landmetrics extension from sources
# 3 install pg_geohash_extra extension from sources
# 4 remove build dependencies
WORKDIR /install-ext
RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
        build-base \
        git \
        make \
    && git clone https://github.com/siose-innova/pg_landmetrics.git \
    && cd pg_landmetrics \
    && make \
    && make install \
    && cd .. \
    && rm -rf pg_landmetrics \
    && git clone https://github.com/siose-innova/pg_geohash_extra.git \
    && cd pg_geohash_extra \
    && make \
    && make install \
    && cd .. \
    && rm -rf pg_geohash_extra \
    && apk del .build-deps

# Copy region of interest
WORKDIR /data
COPY data/spain.* ./

# Set environment variables
ENV POSTGRES_DB siose2014
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD postgres

# Copy Bash script
COPY esin.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/esin.sh

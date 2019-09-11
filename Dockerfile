FROM siose-innova/mf2:2014

RUN apk add --no-cache git make build-base

###########
# Add ROI #
###########
WORKDIR /data
ADD data/spain.* ./

#######################
# Install landmetrics #
#######################
ENV LM https://github.com/siose-innova/pg_landmetrics.git

WORKDIR /install-ext
RUN git clone $LM
WORKDIR /install-ext/pg_landmetrics
RUN make
RUN make install
WORKDIR /
RUN rm -rf /install-ext

###################
# Install geohash #
###################
ENV GEOHASH https://github.com/siose-innova/pg_geohash_extra.git

WORKDIR /install-ext
RUN git clone $GEOHASH
WORKDIR /install-ext/pg_geohash_extra
RUN make
RUN make install
WORKDIR /
RUN rm -rf /install-ext

##############################
# Init DB and run experiment #
##############################
ADD init-db.sh /docker-entrypoint-initdb.d/init-db.sh
#ADD src/sql/split.sql /docker-entrypoint-initdb.d/split.sql

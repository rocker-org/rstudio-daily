FROM rocker/drd

## This handle reaches Carl and Dirk
MAINTAINER "Carl Boettiger and Dirk Eddelbuettel" rocker-maintainers@eddelbuettel.com

ENV DEBIAN-FRONTEND noninteractive  
ENV PATH /usr/lib/rstudio-server/bin/:$PATH   

RUN apt-get update && apt-get install -y --no-install-recommends \
    file \
    git \
    libcurl4-openssl-dev \
    psmisc \
    r-cran-xml \
    supervisor \
    sudo \
&& wget -q http://ftp.us.debian.org/debian/pool/main/o/openssl/libssl0.9.8_0.9.8o-4squeeze14_amd64.deb \ 
&& dpkg -i libssl0.9.8_0.9.8o-4squeeze14_amd64.deb \
&& rm libssl0.9.8_0.9.8o-4squeeze14_amd64.deb \
&& install2.r --error httr 

COPY latest.R .

RUN Rscript latest.R \ 
&& dpkg -i rstudio-server-daily-amd64.deb \
&& rm rstudio-server-*-amd64.deb \
&& ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc /usr/local/bin \
&& ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc-citeproc /usr/local/bin

## This shell script is executed by supervisord when it is run by CMD, configures env variables
COPY userconf.sh /usr/bin/userconf.sh

## Configure persistent daemon serving RStudio-server on (container) port 8787
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8787

## Should we move Rdevel/RD link back to R so that rstudio uses it?
RUN cd /usr/local/bin && mv Rdevel R && mv Rscriptdevel Rscript

## To have a container run a persistent task, we use the very simple supervisord as recommended in Docker documentation.
CMD ["/usr/bin/supervisord"] 



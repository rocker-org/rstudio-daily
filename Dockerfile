FROM rocker/drd

## This handle reaches Carl and Dirk
MAINTAINER "Carl Boettiger and Dirk Eddelbuettel" rocker-maintainers@eddelbuettel.com

ENV DEBIAN-FRONTEND noninteractive  
ENV PATH /usr/lib/rstudio-server/bin/:$PATH   

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
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


## Pandoc templtes for stand-alone mode
RUN mkdir /opt/pandoc \
	&& git clone https://github.com/jgm/pandoc-templates.git /opt/pandoc/templates \
	&& chown -R root:staff /opt/pandoc/templates \
	&& mkdir /root/.pandoc && mkdir -p /home/docker/.pandoc \
	&& ln -s /opt/pandoc/templates /root/.pandoc/templates \
	&& ln -s /opt/pandoc/templates /home/docker/.pandoc/templates  

## Default system configuration:
RUN  git config --system user.name docker \
	&& git config --system user.email docker@email.com \
	&& git config --system push.default simple \
	&& echo '"\e[5~": history-search-backward' >> /etc/inputrc \
	&& echo '"\e[6~": history-search-backward' >> /etc/inputrc 

RUN mkdir -p /var/log/supervisor
COPY userconf.sh /usr/bin/userconf.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 8787
CMD ["/usr/bin/supervisord"] 

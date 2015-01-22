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
&& ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc-citeproc /usr/local/bin \
	&& apt-get clean \ 
	&& rm -rf /var/lib/apt/lists/


## A default user system configuration. For historical reasons,
## we want user to be 'rstudio', but it is 'docker' in r-base
RUN usermod -l rstudio docker \
	&& usermod -m -d /home/rstudio rstudio \
	&& groupmod -n rstudio docker \
	&& git config --system user.name rstudio \
	&& git config --system user.email rstudio@example.com \
	&& git config --system push.default simple \
	&& echo '"\e[5~": history-search-backward' >> /etc/inputrc \
	&& echo '"\e[6~": history-search-backward' >> /etc/inputrc \
	&& echo "rstudio:rstudio" | chpasswd

## RStudio pandoc doesn't provide pandoc templates needed for stand-alone mode outside of RStudio
RUN mkdir /opt/pandoc \
	&& git clone https://github.com/jgm/pandoc-templates.git /opt/pandoc/templates \
	&& chown -R root:staff /opt/pandoc/templates \
	&& mkdir /root/.pandoc \
	&& mkdir -p /home/rstudio/.pandoc \
	&& ln -s /opt/pandoc/templates /root/.pandoc/templates \
	&& ln -s /opt/pandoc/templates /home/rstudio/.pandoc/templates 

## User config and supervisord for persistant RStudio session
COPY userconf.sh /usr/bin/userconf.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN mkdir -p /var/log/supervisor \
	&& chgrp staff /var/log/supervisor \
	&& chmod g+w /var/log/supervisor \
	&& chgrp staff /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8787

## Have RStudio run with the pre-release R as well
RUN cd /usr/local/bin \
  && mv Rdevel R \
  && mv Rscriptdevel Rscript

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"] 

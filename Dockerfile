FROM perl:5.20

RUN curl -sL https://deb.nodesource.com/setup_9.x | bash -

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y \
  apt-transport-https \
  nodejs \
  yarn

RUN cpanm Carton
RUN mkdir -p /cpan
RUN mkdir -p /usr/src/perl-Intern-Diary

WORKDIR /cpan
COPY cpanfile .
RUN carton install

ENV PATH=/cpan/local/bin:$PATH
ENV PERL5LIB=/cpan/local/lib/perl5

WORKDIR /usr/src/perl-Intern-Diary
COPY . /usr/src/perl-Intern-Diary

RUN rm -rf node_modules
# QUESTION: it does not create node_modules
RUN yarn install

CMD script/appup

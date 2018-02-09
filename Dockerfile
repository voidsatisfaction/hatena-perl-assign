FROM perl:5.20

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

CMD script/appup

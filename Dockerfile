FROM perl:5.20

COPY . /usr/src/perl-Intern-Diary
WORKDIR /usr/src/perl-Intern-Diary

RUN cpanm Carton
RUN rm -rf local/
RUN carton install

CMD perl leave.pl
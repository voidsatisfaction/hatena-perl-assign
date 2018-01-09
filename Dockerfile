FROM mysql:5.7.20

EXPOSE 3306

COPY . /usr/src/perl-Intern-Diary
WORKDIR /usr/src/perl-Intern-Diary

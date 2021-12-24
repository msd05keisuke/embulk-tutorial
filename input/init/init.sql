use db_input;

CREATE TABLE input (
  id int(10) unsigned not null auto_increment,
  name varchar(10) not null,
  primary key (id)
);

insert into input(name) values('hogehoge');
insert into input(name) values('poyopoyo');
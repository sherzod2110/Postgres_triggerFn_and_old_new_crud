
create table products(
    product_id uuid default uuid_generate_v4() primary key,
    product_title varchar(64) not null,
    product_price bigint not null
);  

insert into products(product_title, product_price) values('Coca-cola', 10000),
                          ('Fanta', 9000),
                          ('Sprite', 9000);
delete from products where product_id = '';

create or replace function deleteFn()
returns trigger
language plpgsql
as
$$
begin

    insert into arxiv_delete_products(arxived_id, arxived_title, arxived_price) values(OLD.product_id, OLD.product_title, OLD.product_price);
    return OLD;

end
$$;

create or replace function insertFn()
returns trigger
language plpgsql
as
$$
begin

    insert into arxiv_create_products(arxived_crete_id, arxived_crete_title, arxived_crete_price) values(NEW.product_id, NEW.product_title, NEW.product_price);
    return NEW;

end
$$;

create or replace function updateFn()
returns trigger
language plpgsql
as
$$
begin

    if 
        NEW.product_title != OLD.product_title
    then
        insert into arxiv_update_products(arxived_update_id, arxived_update_title) values(OLD.product_id, OLD.product_title || ' ning title ' || NEW.product_title || ' ga uzgardi');
    elsif
        NEW.product_price != OLD.product_price
    then
        insert into arxiv_update_products(arxived_update_id, arxived_update_title) values(OLD.product_id, OLD.product_title || ' ning narxi ' || NEW.product_price || ' ga uzgardi');
    end if;
    return NEW;

end
$$;

drop table if exists arxiv_delete_products cascade;
create table arxiv_delete_products(
    arxived_id uuid,
    arxived_title varchar,
    arxived_price bigint,
    deleted_at timestamptz default current_timestamp
);


create table arxiv_create_products(
    arxived_crete_id uuid,
    arxived_crete_title varchar,
    arxived_crete_price bigint,
    deleted_crete_at timestamptz default current_timestamp
);

create table arxiv_update_products(
    arxived_update_id uuid,
    arxived_update_title varchar,
    arxived_update_price bigint,
    deleted_update_at timestamptz default current_timestamp
);

DROP TRIGGER [IF EXISTS] insertTrigger;
create trigger inserTrigger
before insert
on products
for each row
execute procedure insertFn();

create trigger deleteTrigger
before delete
on products
for each row
execute procedure deleteFn();

create trigger updateTrigger
before update
on products
for each row
execute procedure updateFn();
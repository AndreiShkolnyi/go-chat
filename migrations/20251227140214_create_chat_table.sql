-- +goose Up
create table chat (
    id serial primary key,
    fromText text not null,
    messageText text not null,
    createdAt timestamp not null default now()
);

-- +goose Down
drop table chat;

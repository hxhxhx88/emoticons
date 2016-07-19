# Emoticons Server
---

# Prerequisite

## Install bundles

> bundle install

## Create the credential file

Write following to `config/database.yml`

```ruby

development:
  adapter: postgresql
  encoding: UTF-8
  host: localhost
  database: database
  username: username
  password: password
  port: 5432
  pool: 10
```

# Run

> rackup

# Usage

Refer to test/Makefile, or view

> localhost:9292/admin

# TODO

- Advanced mode in search API

  I think it is trivial in the API level, which just need to change the ORDER BY clause. The work is to write a script to calculate a rank for each emoticon, based on publish time, download count, etc.

- Detail of returned JSON

  Please modify the code to fit the need.

- Add a website interface

  The website should like the homepage of Google.

# Possible Issue

- To me, the two tables `emoticons` and `images` are kind of confusing, so please modify the code if necessory. For example, I assumed that the column `image_id` on the `emoticons_tags` table is referring to `id` of `emoticons`, instead of `images`, so I changed the name of it.

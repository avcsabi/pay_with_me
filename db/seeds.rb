# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

merchant1 = Merchant.create!(name: 'John', description: 'First user',
                             admin: true, email: 'john@coffee.shop', password: "John's secret",
                             password_confirmation: "John's secret")
merchant2 = Merchant.create!(name: 'Csabi', description: 'Dev user',
                             admin: true, email: 'csabi@devs.club', password: "Csabi's secret",
                             password_confirmation: "Csabi's secret")
merchant3 = Merchant.create!(name: 'Emag', description: 'Big store',
                             admin: false, email: 'office@emag.eu', password: "Emag's secret",
                             password_confirmation: "Emag's secret")
merchant4 = Merchant.create!(name: 'Dedeman', description: 'Good store of two brothers',
                             admin: false, email: 'wefixit@dedeman.eu', password: "Dedeman's secret",
                             password_confirmation: "Dedeman's secret")
merchant1.transactions.create!(type: 'AuthorizeTransaction', uuid: SecureRandom.uuid,
                               amount: 1000, status: 'declined', customer_email: 'some_client@gmail.com',
                               notification_url: 'http://localhost:3000/api/echo')
merchant2.transactions.create!(type: 'AuthorizeTransaction', uuid: SecureRandom.uuid,
                               amount: 5000, status: 'approved', customer_email: 'some_client2@gmail.com',
                               notification_url: 'http://localhost:3000/api/echo')
merchant3.transactions.create!(type: 'AuthorizeTransaction', uuid: SecureRandom.uuid,
                               amount: 10_000, status: 'approved', customer_email: 'some_client3@gmail.com',
                               notification_url: 'http://localhost:3000/api/echo')
merchant4.transactions.create!(type: 'AuthorizeTransaction', uuid: SecureRandom.uuid,
                               amount: 20_000, status: 'approved', customer_email: 'some_company@gmail.com',
                               notification_url: 'http://localhost:3000/api/echo')

# README

About the app

### Ruby version
3.2.1

### System dependencies
nothing special

### Configuration

From the root of the project run:
```
bundle
```

### Database creation

From the root of the project run:
```
rake db:create
```

### Database initialization

From the root of the project run:
```
rake db:migrate
rake db:seed
```

### How to run the test suite

From the root of the project run:
```
rspec spec/
```

### Services (job queues, cache servers, search engines, etc.)

From the root of the project in a dedicated terminal run:
```
rake delayed:work
```

### Deployment instructions
only for local use

### How to use the app after loading the seeds and starting the local server
Visit: http://127.0.0.1:3000
You can either log in as a merchant or an admin.

To log in as an admin enter email: csabi@devs.club and password: Csabi's secret

To log in as a merchant enter email: office@emag.eu and password: Emag's secret

To log out click the Logout button at the bottom of each page.

To make transactions use Postman or similar. See rspec tests for examples.

To transition new transaction from pending to approved or declined and to send notification run the worker (rake delayed:work)

If you set the notification url to http://localhost:3000/api/notification_to_file then when the
notification is sent a file with name similar to "notification_approved_xxx.json" will be saved in the tmp folder.

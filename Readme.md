#### Setup

````
$ vagrant up
````

`$ vagrant ssh puppet` to log in to Puppet Master server

`localhost:5000` Puppet managed infrastructure view by Puppetboard

`localhost:3000` to access Uchiwa dashboard display overview of Sensu

`localhost:15672` to manage RabbitMQ middleware

`localhost:8080` Kibana dashboard for centralised logs

`localhost:9090` Jenkins

#### Create a self-signed SSL certificate on OSX (if needed for logstash-forwarder)

````
$ openssl genrsa -out ssl.key 2048
$ openssl req -new -key ssl.key -batch -out ssl.csr
$ openssl req -x509 -days 3650 -in ssl.csr -key ssl.key -out ssl.crt
````

#### TODO

-- Documentation


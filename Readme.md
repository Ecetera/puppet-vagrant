#### Setup

1. Populate `puppet/data/vagrant.yaml` file with your values

After you may want to run the following to tell git to ignore the above changes.

````
git update-index --assume-unchanged puppet/data/vagrant.yaml
````

Then run

````
$ vagrant up
````

`$ vagrant ssh puppet` to log in to Puppet Master server if needed

Or access services at the following URLs:

http://localhost:5000 Puppet managed infrastructure view by Puppetboard

http://localhost:3000 to access Uchiwa dashboard display overview of Sensu

http://localhost:15672 to manage RabbitMQ middleware

http://localhost:8080 Kibana dashboard for centralised logs

http://localhost:9090 Jenkins

#### Create a self-signed SSL certificate on OSX (if needed for logstash-forwarder)

````
$ openssl genrsa -out ssl.key 2048
$ openssl req -new -key ssl.key -batch -out ssl.csr
$ openssl req -x509 -days 3650 -in ssl.csr -key ssl.key -out ssl.crt
````

#### TODO

-- Documentation


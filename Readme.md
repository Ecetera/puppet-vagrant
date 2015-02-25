#### Setup

1. Populate `puppet/data/vagrant.yaml` file with appropriate values:
  - Git `remote` of puppet-control repo under `r10k::sources`
  - Under `ssh_keys`, name the resource and add host `key` of the Gitlab server
  - Gitlab `server_url` and Gitlab API `token`

2. You may want to run the following to tell git to ignore the above changes.

    ```
    $ git update-index --assume-unchanged puppet/data/vagrant.yaml
    ```

3. Pull down submodules needed to bootstrap Puppet install with the following script:

    ```
    $ ./init-submodules.sh
    ```

4. If using AWS or DigitalOcean providers populate `~/.cloud_profile`

    ```
    #!/bin/bash
    
    export AWS_KEY=
    export AWS_SECRET=
    export AWS_KEYNAME=
    export AWS_KEYPATH=
    export DO_TOKEN=
    export DO_KEYPATH=
    ```

5. To spin up Puppet Master locally run

    ```
    $ vagrant up puppet
    ```

or at DigitalOcean

    ```
    $ vagrant up puppet --provider=digital_ocean
    ```

Access services at the following URLs:

http://localhost:5000 Puppet managed infrastructure view by Puppetboard

http://localhost:3000 to access Uchiwa dashboard display overview of Sensu

http://localhost:15672 to manage RabbitMQ middleware

http://localhost:8080 Kibana dashboard for centralised logs

http://localhost:9090 Jenkins

#### Create a self-signed SSL certificate on OSX (if needed for logstash-forwarder)

```
$ openssl genrsa -out ssl.key 2048
$ openssl req -new -key ssl.key -batch -out ssl.csr
$ openssl req -x509 -days 3650 -in ssl.csr -key ssl.key -out ssl.crt
```

#### TODO

-- Documentation


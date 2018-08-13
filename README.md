# EC2 PHP Bootstrap

## Install Instructions

- Install [Docker](https://docs.docker.com/install/) for your environment
- Clone the repository:

```sh
git clone git@github.com:monosolutions/EC2-PHP-Bootstrap.git
```

- Go into the newly created folder and run the following command:

```sh
 docker-compose up --force-recreate --build
```

By now you should have a PHP 7 environment running in a terminal window

If you need to do any interactions (e.g. run `composer`)

- Initialise the Docker environment (This will make the environment run in the background)

```sh
docker-compose start
```

- Run composer:

```sh
docker-compose run --rm --workdir=/code  php composer install
```

- If you need to rebuild the docker instance you can use the following command

```sh
docker-compose up --force-recreate --build
```

- To access the application you can configure your gas mask / host file to point a `.test` URL to 127.0.0.1

```sh
sudo vim /etc/hosts

127.0.0.1   mono.test
```

- Copy environment options:

```sh
cp .env.dist .env
```
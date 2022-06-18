all: build_go build_php_mysql_light


#create_go_tag:
#	docker tag 90a041ae3357 brdnlsrg/baseimage:go-latest

push_go:
	docker push brdnlsrg/baseimage:go-latest

push_php_light:
	docker push brdnlsrg/baseimage:php-light

build_go:
	docker build --pull -t brdnlsrg/baseimage:go-latest build.go -f build.go/Dockerfile

build_php_light:
	docker build --pull -t brdnlsrg/baseimage:php-light build.php -f build.php/php7.4-dev-fpm-light/Dockerfile

build_php_pgsql_light:
	docker build --pull -t brdnlsrg/baseimage:php-pgsql-light build.php -f build.php/php7.4-dev-fpm-light/Dockerfile

build_php_dev_full:
	docker build --pull -t brdnlsrg/baseimage:php-dev-full build.php -f build.php/php7.4-dev-fpm/Dockerfile
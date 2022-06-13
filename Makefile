all: build_go build_php_mysql_light


#create_go_tag:
#	docker tag 90a041ae3357 brdnlsrg/baseimage:go-latest

push_go:
	docker push brdnlsrg/baseimage:go-latest

build_go:
	docker build --pull -t brdnlsrg/baseimage:go-latest build.go -f build.go/Dockerfile

build_php_mysql_light:
	docker build --pull -t brdnlsrg/baseimage:php-mysql-light build.php -f build.php/php7.4-dev-fpm-light/Dockerfile

build_php_pgsql_light:
	docker build --pull -t brdnlsrg/baseimage:php-pgsql-light build.php -f build.php/php7.4-dev-fpm-light/Dockerfile
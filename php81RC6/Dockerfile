FROM php:8.1.0RC6-fpm-alpine3.14
RUN apk --no-cache add wget bash \ 
	&& wget https://get.symfony.com/cli/installer -O - | bash \
	&& mv /root/.symfony/bin/symfony /usr/local/bin/symfony

RUN apk add \
		acl \
		file \
		gettext \
		git \
                nodejs \
                yarn \
                unzip \
                npm

ARG APCU_VERSION=5.1.17
RUN set -eux; \
	apk add --virtual .build-deps \
		$PHPIZE_DEPS \
		icu-dev \
		libzip-dev \
		postgresql-dev \
		zlib-dev \
	; \
	\
	docker-php-ext-configure zip --with-zip; \
	docker-php-ext-install -j$(nproc) \
		intl \
		pdo_mysql \
        pdo_pgsql \
		zip \
	; \
	pecl install \
		apcu-${APCU_VERSION} \
	; \
	pecl clear-cache; \
	docker-php-ext-enable \
		apcu \
		opcache \
	; \
	\
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --virtual .api-phpexts-rundeps $runDeps; \
	\
	apk del .build-deps

RUN apk add --no-cache \
    freetype \
    libpng \
    libjpeg-turbo \
    freetype-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    && docker-php-ext-configure gd \
    --with-webp \
    --with-freetype \
    --with-jpeg \
    && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
    docker-php-ext-install -j${NPROC} gd && \
    apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev


RUN apk add --no-cache  \
            --repository http://dl-cdn.alpinelinux.org/alpine/edge/main  \
            --repository  http://dl-cdn.alpinelinux.org/alpine/edge/community \
            docker \
            docker-compose

VOLUME /var/lib/docker

COPY --from=composer /usr/bin/composer /usr/bin/composer

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

COPY conf.d/php.ini $PHP_INI_DIR/conf.d/php.ini

WORKDIR /srv/app
EXPOSE 8000
ENTRYPOINT ["docker-entrypoint"]
CMD ["php-fpm"]

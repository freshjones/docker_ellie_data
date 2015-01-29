# Set the base image to debian
FROM debian:jessie

# File Author / Maintainer
MAINTAINER William Jones <billy@freshjones.com>

VOLUME ["/app/laravel"]

CMD ["/bin/sh"]


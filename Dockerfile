FROM quay.io/pypa/manylinux2014_x86_64

RUN yum -y update; yum clean all

RUN yum -y install boost-devel

ENV PATH="/opt/python/cp38-cp38/bin/:$PATH"

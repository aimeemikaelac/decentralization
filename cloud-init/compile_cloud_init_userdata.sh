#!/bin/bash

#create tarball of puppet config and cloud-init to call puppet config
tar zcf cloud-init.tar.gz ../puppet

#create user-data file using the write-mime-multipart program 
#is part of the ubuntu cloud-image-utils package

write-mime-multipart --output user-data cloud-init.txt part-handler-mico8428.py:text/part-handler cloud-init.tar.gz:application/x-tar

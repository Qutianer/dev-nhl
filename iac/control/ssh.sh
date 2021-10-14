#!/bin/bash

ssh -t adminuser@$( sed -n '2p' ) 'sudo su -; bash -l'

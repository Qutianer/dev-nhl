#!/bin/bash

ssh -t adminuser@$( sed -n '2p' inventory ) 'sudo su -; bash -l'

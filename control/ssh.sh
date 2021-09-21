#!/bin/bash

ssh -t adminuser@$( sed '2q;d' inventory ) 'sudo su -; bash -l'

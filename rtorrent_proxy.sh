#!/bin/sh


function rtorrent_proxy()
 {
   port=3128
   proxyhost=192.168.1.3
   http_proxy="http://$proxyhost:$port/" rtorrent
 }

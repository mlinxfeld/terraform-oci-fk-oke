#!/bin/bash

%{ for node_pool_host_name, node_pool_private_ip in node_pool_ips ~}
kubectl taint nodes ${node_pool_private_ip} autoscaler=true:NoSchedule
%{ endfor ~}

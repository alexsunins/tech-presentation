#! /bin/bash

instance_type_arr=( 'postgres' 'rabbitmq' )
instance_port_arr=( 5432 15672 )

printf '\n%s\n\n' 'Please select a type of instance:'
for (( i=0; i<${#instance_type_arr[@]}; i++ )); do
    printf '\t%s\n' "[$i]: ${instance_type_arr[$i]}"
done

read -p "" arr_idx
target_port=${instance_port_arr[$arr_idx]}

while read line; do
    instance_arr=("${instance_arr[@]}" $line)
done <<<$(gcloud compute instances list --filter="name ~ ${instance_type_arr[$arr_idx]}" --format='value(name)')

printf '\n%s\n\n' 'Please select an instance to establish IAP tunnel to:'
for (( i=0; i<${#instance_arr[@]}; i++ ));
do
  printf '[%s] %s\n' $i ${instance_arr[$i]}
done

read -p "" arr_idx

read -p "Please choose a local port to run the tunnel on: " local_instance_port

instance_zone=$( gcloud compute instances list --filter="name: ${instance_arr[$arr_idx]}" --format='value(zone)' )

printf '\n%s\n\n' "Establishing IAP tunnel to ${instance_arr[$arr_idx]} on $target_port in zone $instance_zone, the tunnel will run locally on $local_instance_port"

gcloud compute start-iap-tunnel ${instance_arr[$arr_idx]} $target_port \
    --local-host-port=localhost:$local_instance_port \
    --zone=$instance_zone


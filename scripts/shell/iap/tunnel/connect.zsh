#! /bin/zsh

instance_type_arr=( 'postgres' 'rabbitmq' )
instance_port_arr=( 5432 15672 )

printf '\n%s\n\n' 'Please select a type of instance:'
for i in $(seq ${#instance_type_arr}); do
    printf '\t%s\n' "[$i]: ${instance_type_arr[$i]}"
done

read "REPLY?"

target_port=${instance_port_arr[$REPLY]}
instance_arr=( $(gcloud compute instances list --filter="name ~ ${instance_type_arr[$REPLY]}" --format='value(name)') )

printf '\n%s\n\n' 'Please select an instance to establish IAP tunnel to:'
for i in $(seq 1 ${#instance_arr}); do
    printf '[%s] %s\n' $i ${instance_arr[$i]}
done

read "REPLY?"
arr_idx=$REPLY

read "REPLY?Please choose a local port to run the tunnel on: "
local_instance_port=$REPLY

instance_zone=$( gcloud compute instances list --filter="name: ${instance_arr[$arr_idx]}" --format='value(zone)' )

printf '\n%s\n\n' "Establishing IAP tunnel to ${instance_arr[$arr_idx]} on port $target_port in zone $instance_zone, the tunnel will run locally on $local_instance_port"

gcloud compute start-iap-tunnel ${instance_arr[$arr_idx]} $target_port \
    --local-host-port=localhost:$local_instance_port \
    --zone=$instance_zone

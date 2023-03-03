#!/bin/bash

echo "Checking Service Status"

status_check () {
    max_time=5
    start_time=0
    repeat_serivce () {
      if [ $service_name == "$1" ]
      then
      https_code=$(curl -s -o /dev/null -w "%{http_code}" https://{$1}.dev.ma.halo-telekom.{$2})
        if [ $https_code = "200" ]
        then 
          echo "$service_name service has started"
        else
          until [ $start_time == "$max_time" ]
          do
            start_time=$(( start_time + 1 ))
            sleep 1
            https_code=$(curl -s -o /dev/null -w "%{http_code}" https://{$1}.dev.ma.halo-telekom.{$2})
            if [ $https_code == "200" ]
            then
              echo "$service_name service has started"
              break
            else
              echo "wait ${start_time}s"
            fi
          done
        fi
      fi
    }
    
    repeat_serivce persona com/persona-service/
    repeat_serivce gateway com/
    repeat_serivce insights com/insights-service/ 

    
    if [ $start_time -eq $max_time ]
    then
       echo "$service_name service has not started, Please check the service log"
    fi
}

for service_name in $(cat build-summary.txt); do
status_check $service_name
done

#!/bin/bash

echo "Checking Service Status"

curl_https_url () {
    max_in_s=$2
    delay_in_s=1
    total_in_s=0
    while [ $total_in_s -le "$max_in_s" ]
    do
        echo "Wait ${total_in_s}s"
        https_code=$(curl -s -o /dev/null -w "%{http_code}" https://ui.${CI_COMMIT_BRANCH}.ma.halo-telekom.com/)
        if [ $https_code != "200" ]
        then
            total_in_s=$(( total_in_s +  delay_in_s))
            sleep $delay_in_s
        else
            echo 'Service has successfully started '
            exit
            
        fi
       
    done
echo 'Service has not started, Please check the service log'
}

curl_https_url 'https://ui.${CI_COMMIT_BRANCH}.ma.halo-telekom.com/' 90

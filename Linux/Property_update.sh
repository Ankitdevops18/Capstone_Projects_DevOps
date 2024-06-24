#!/bin/bash
## This Job is to automate property file update after dataload B&Ds are executed 
## Instructions to run : Give argument as either article, price or promo to update properties file accordingly after the respective B&Ds

InputJob=$1
FILE_PATH="/digital-batch/qa/properties/"

if [ "${InputJob}" = "article" ]; then
    cd ${FILE_PATH}/article/
    echo "Starting property files Updated for All QA Environments after Article Dataload B&D"
    sed -i -e 's/'"com.bjs.datasource.db2.password=password"'/'"com.bjs.datasource.db2.password=P9K3l0xX"'/g' application-split-sap-feed-qa1.properties
    sed -i -e 's/'"com.bjs.datasource.db2.password=password"'/'"com.bjs.datasource.db2.password=Mi78CpK9"'/g' application-split-sap-feed-qa2.properties
    sed -i -e 's/'"com.bjs.datasource.db2.password=password"'/'"com.bjs.datasource.db2.password=jI4z29p1"'/g' application-split-sap-feed-qa4.properties
    sed -i -e 's/'"com.bjs.datasource.db2.password=password"'/'"com.bjs.datasource.db2.password=Z13pR9Qm"'/g' application-split-sap-feed-qa5.properties
    echo "Property Files Updated for All QA Environments after Article Dataload B&D"


elif [ "${InputJob}" = "price" ]; then
    cd ${FILE_PATH}/price/
    echo "Starting property files Updated for All QA Environments after Price Dataload B&D"
    sed -i -e 's/'"com.bjs.datasource.db2.password=password"'/'"com.bjs.datasource.db2.password=P9K3l0xX"'/g' application-price-feed-qa1.properties
    sed -i -e 's/'"com.bjs.datasource.db2.password=password"'/'"com.bjs.datasource.db2.password=Mi78CpK9"'/g' application-price-feed-qa2.properties
    sed -i -e 's/'"com.bjs.datasource.db2.password=password"'/'"com.bjs.datasource.db2.password=jI4z29p1"'/g' application-price-feed-qa4.properties
    sed -i -e 's/'"com.bjs.datasource.db2.password=password"'/'"com.bjs.datasource.db2.password=Z13pR9Qm"'/g' application-price-feed-qa5.properties
    echo "Property Files Updated for All QA Environments after Price Dataload B&D"


elif [ "${InputJob}" = "promo" ]; then
    cd ${FILE_PATH}/promo/ 
    echo "Starting property files Updated for All QA Environments after Promo Dataload B&D"
    sed -i -e 's/'"com.bjs.datasource.db2.password=password"'/'"com.bjs.datasource.db2.password=P9K3l0xX"'/g' application-qa1.properties
    sed -i -e 's/'"com.bjs.datasource.db2.password=password"'/'"com.bjs.datasource.db2.password=Mi78CpK9"'/g' application-qa2.properties
    sed -i -e 's/'"com.bjs.datasource.db2.password=password"'/'"com.bjs.datasource.db2.password=jI4z29p1"'/g' application-qa4.properties
    sed -i -e 's/'"com.bjs.datasource.db2.password=password"'/'"com.bjs.datasource.db2.password=Z13pR9Qm"'/g' application-qa5.properties
    echo "Property Files Updated for All QA Environments after Promo Dataload B&D"  

elif [ "${InputJob}" = "abandoned" ]; then
    cd /wcsextracts/dataload/abandonedcart/conf/
    echo "Starting property files Updated"
    sed -i -e 's/'"password:"'/'"password: DB2s3cr3t\!"'/g' application-abandoned-cart-data-load-qa1.yml

else 

    echo "Wrong choice of Job"

fi







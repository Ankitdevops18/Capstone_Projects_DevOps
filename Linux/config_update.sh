#!/bin/bash
# webserverUpdateServername.sh
#

function usage(){
  echo "Executing ${FUNCNAME}"
  echo "
    Usage: ${0} <qa or prod or full prod  >

    For eg :
        1. For Qa run >> webserverUpdateServername.sh qa
        2. For Prod run >> webserverUpdateServername.sh prod
	3. For Full Prod run >> webserverUpdateServername.sh fullprod

    This script updates  admin.conf, plugin-cfg and httpd.conf after taking a backup
    from the directory /apps/ihs/conf
  "
}

function updateFile(){
  echo "Executing ${FUNCNAME}"
  local FILENAME="${1}"
  echo " File name is : $FILENAME"
  
  
  if [ "${InputEnv}" == "prod" ] && [[ "${FILENAME}" == *"plugin-cfg.xml"* ]]
  then
  {
   OLD_HOSTNAME="${OLD_HOSTNAME}\."
   NEW_HOSTNAME="${NEW_HOSTNAME}."
   echo " Given File is Plugin and new hostname:${NEW_HOSTNAME}"
  }
  else
   echo " File:$FILENAME"
  fi


  if [ ! -e "${FILENAME}" ];then echo "File: ${FILENAME} does not exist."; return 9; fi
  
  cp -pr ${FILENAME}{,.${DT}}
  
  if [ -n "${OLD_HOSTNAME}" -a -n "${NEW_HOSTNAME}" ];then
    echo " File $FILENAME"
    sed -i -e 's/'"${OLD_HOSTNAME}"'/'"${NEW_HOSTNAME}"'/g' ${FILENAME}
  fi
  
  if [ -n "${OLD_DOMAINNAME}" -a -n "${NEW_DOMAINNAME}" ];then
    sed -i -e 's/'"${OLD_DOMAINNAME}"'/'"${NEW_DOMAINNAME}"'/g' ${FILENAME}
  fi
  
}

function updateallhosts(){

	echo "Executing ${FUNCNAME}"
	local FILENAME="${1}"
	echo " File name is : $FILENAME"
	
	INPUT_FILE="${SCRIPTS_DIR}/${InputEnv}/changeWCSHostname.txt"
	mapfile -t lines < ${INPUT_FILE}
	for line in "${lines[@]}"; do
		FROM=$(echo $line | cut -d ":" -f 1)
		TO=$(echo $line | cut -d ":" -f 2)
  
		if [ -n "${FROM}" -a -n "${TO}" ];then
			echo "----------------------------------------------------------------"
			echo "------------ UPDATE HOSTNAME FROM ${FROM} TO ${TO} -------------"
			echo "----------------------------------------------------------------"
			echo "Changing for ${FILENAME}"
			sed -i -e 's/'"\b${FROM}\b"'/'"${TO}"'/g' ${FILENAME}
			
		fi
	done

}


function main(){
	echo "Executing ${FUNCNAME}"
	echo "Updating httpd.conf"
	updateFile "/apps/ihs/conf/httpd.conf"
	echo "Updating admin.conf"
	updateFile "/apps/ihs/conf/admin.conf"
	updateallhosts "/apps/ihs/conf/admin.conf"
#echo "updating the plugin-cfg.xml file "
#updateFile "/apps/Plugins/config/webserver1/plugin-cfg.xml"
#updateallhosts "/apps/Plugins/config/webserver1/plugin-cfg.xml"
	echo "----------------------------------------------------------------"
	echo "---------------Files updated successfully-----------------------"
	echo "----------------------------------------------------------------"
}


##Script Starts here =>

InputEnv=$1

if [ "${InputEnv}" = "qa" ]; then
   OLD_HOSTNAME_WITH_DOMAIN="ue00comaps01.qa1-wcs-stage.bjs.com"
   NEW_HOSTNAME_WITH_DOMAIN="ue02comaps01.qa1-wcs-stage-ue2.bjs.com"

elif [ "${InputEnv}" = "prod" ];then
   OLD_HOSTNAME_WITH_DOMAIN="ue00comapp01.wcs.bjs.com"
   NEW_HOSTNAME_WITH_DOMAIN="ue02comapp01.wcs-ue2.bjs.com"

elif [ "${InputEnv}" = "fullprod" ];then
   OLD_HOSTNAME_WITH_DOMAIN="ue00comapp01.wcs.bjs.com"
   NEW_HOSTNAME_WITH_DOMAIN="ue02comapp01.wcs-ue2.bjs.com"   
else
   echo "Wrong Environment selection"
fi


SCRIPTS_DIR="/scratch/DR_Scripts"
OLD_HOSTNAME="$(echo ${OLD_HOSTNAME_WITH_DOMAIN} |awk -F. '{print $1}')"
OLD_DOMAINNAME="$(echo ${OLD_HOSTNAME_WITH_DOMAIN} |sed -e 's/'"${OLD_HOSTNAME}"'\.\?//')"
NEW_HOSTNAME="$(echo ${NEW_HOSTNAME_WITH_DOMAIN} |awk -F. '{print $1}')"
NEW_DOMAINNAME="$(echo ${NEW_HOSTNAME_WITH_DOMAIN} |sed -e 's/'"${NEW_HOSTNAME}"'\.\?//')"
DT="`date +%Y%m%d_%H%M%S`"

echo "Inputs given are Old Hostname = ${OLD_HOSTNAME} , New Hostname = ${NEW_HOSTNAME} , Old DOmain Name = ${OLD_DOMAINNAME} & New Domain Name = ${NEW_DOMAINNAME}"

if [ -z "${OLD_HOSTNAME_WITH_DOMAIN}" -o -z "${NEW_HOSTNAME_WITH_DOMAIN}" ];then
  usage
else
  main
fi

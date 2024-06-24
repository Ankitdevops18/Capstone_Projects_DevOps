#!/bin/bash
# changeWCSHostname.sh
#Give argument as either qa or prod or fullprod while running this script



#Functions Definitions >>

function changeHostnameInFiles(){
  echo "Executing ${FUNCNAME}..."
  INPUT_FILE="${SCRIPTS_DIR}/${InputEnv}/changeWCSHostname.txt"
  mapfile -t lines < ${INPUT_FILE}
  for line in "${lines[@]}"; do
	FROM=$(echo $line | cut -d ":" -f 1)
	TO=$(echo $line | cut -d ":" -f 2)

	if [ -n "${FROM}" -a -n "${TO}" ];then
		echo "----------------------------------------------------------------"
		echo "------------ UPDATE HOSTNAME FROM ${FROM} TO ${TO} -------------"
		echo "----------------------------------------------------------------"
		for F in $(awk '{print $0}' ${SCRIPTS_DIR}/${InputEnv}/Files2Update.txt); do
		echo "Changing for ${F}"
		sed -i -e 's/'"\b${FROM}\b"'/'"${TO}"'/g' ${F}
		done
	fi
  done

  for F in $(awk '/resources.xml|wc-server.xml/{print $0}' ${SCRIPTS_DIR}/${InputEnv}/Files2Update.txt); do
      echo "Changing for ${F} from ue00 to ue02 "
      sed -i -e 's/'"ue00"'/'"ue02"'/g' ${F}
  done

  cp /apps/was/AppServer/profiles/BJSECOM/installedApps/Cell01/WC_BJSECOM.ear/xml/config/wc-server.xml /apps/wcs/CommerceServer80/instances/BJSECOM/xml/BJSECOM.xml

  for F in $(awk '/virtualhosts.xml/{print $0}' ${SCRIPTS_DIR}/${InputEnv}/Files2Update.txt); do
      echo "Changing for ${F} from ${UE1_HOST_ALIAS} to ${UE2_HOST_ALIAS}"
      sed -i -e 's/'"${UE1_HOST_ALIAS}"'/'"${UE2_HOST_ALIAS}"'/g' ${F}
  done
}


function changeHostnameInFilesFullProd(){
  echo "Executing ${FUNCNAME}..."
  INPUT_FILE="${SCRIPTS_DIR}/${InputEnv}/changeWCSHostname.txt"
  mapfile -t lines < ${INPUT_FILE}
  for line in "${lines[@]}"; do
	FROM=$(echo $line | cut -d ":" -f 1)
	TO=$(echo $line | cut -d ":" -f 2)

	if [ -n "${FROM}" -a -n "${TO}" ];then
		echo "----------------------------------------------------------------"
		echo "------------ UPDATE HOSTNAME FROM ${FROM} TO ${TO} -------------"
		echo "----------------------------------------------------------------"
		for F in $(awk '{print $0}' ${SCRIPTS_DIR}/${InputEnv}/Files2Update.txt); do
		echo "Changing for ${F}"
		sed -i -e 's/'"\b${FROM}\b"'/'"${TO}"'/g' ${F}
		done
	fi
  done



  for F in $(awk '/resources.xml|wc-server.xml/{print $0}' ${SCRIPTS_DIR}/${InputEnv}/Files2Update.txt); do
      echo "Changing for ${F} from ue00 to ue02"
      sed -i -e 's/'"ue00"'/'"ue02"'/g' ${F}
  done

  for F in $(awk '/resources.xml|wc-server.xml/{print $0}' ${SCRIPTS_DIR}/${InputEnv}/Files2Update.txt); do
      echo "Changing for ${F} from ue00 to ue02"
      sed -i -e 's/'"ue02comdbp01"'/'"ue02comdbp02"'/g' ${F}
  done

  cp /apps/was/AppServer/profiles/BJSECOM/installedApps/Cell01/WC_BJSECOM.ear/xml/config/wc-server.xml /apps/wcs/CommerceServer80/instances/BJSECOM/xml/BJSECOM.xml

  for F in $(awk '/virtualhosts.xml/{print $0}' ${SCRIPTS_DIR}/${InputEnv}/Files2Update.txt); do
      echo "Changing Domain Name for ${F} from ${UE1_HOST_ALIAS} to ${UE2_HOST_ALIAS}"
      sed -i -e 's/'"${UE1_HOST_ALIAS}"'/'"${UE2_HOST_ALIAS}"'/g' ${F}
  done
}

function changeHostname(){
  echo "----------------------------------------------------------------"
  echo "Executing ${FUNCNAME}..."
  echo "----------------------------------------------------------------"
  F="${SCRIPTS_DIR}/${InputEnv}/HostName_Change.py"
  if [ -r "${F}" ];then
    ${DMGR_PROF_DIR}/bin/wsadmin.sh -conntype none -lang jython -f ${F}
    RC=$?
    if [ "${RC}" -ne 0 ]; then echo "Error! wsadmin.sh for file ${F} failed."
    else
       echo "Job Run Successful! wasdmin.sh for file ${F} ran successfully"
    fi
  else
    echo "Error! File: ${F} does not exist or is not readable.";
  fi

}

function changeHostname_s(){
  echo "----------------------------------------------------------------"
  echo "Executing ${FUNCNAME}..."
  echo "----------------------------------------------------------------"
  F="${SCRIPTS_DIR}/${InputEnv}/HostName_Change.py"
  if [ -r "${F}" ];then
    ${APP_PROF_DIR}/bin/wsadmin.sh -conntype none -lang jython -f ${F}
    RC=$?
    if [ "${RC}" -ne 0 ]; then echo "Error! wsadmin.sh for file ${F} failed."
    else
       echo "Job Run Successful! wasdmin.sh for file ${F} ran successfully"
    fi
  else
    echo "Error! File: ${F} does not exist or is not readable.";
  fi

}


#Variables Initialisation >>


InputEnv=$1
SCRIPTS_DIR="/scratch/DR_Scripts"
WAS_APP_DIR="/apps/was/AppServer"
PROFILES_DIR="${WAS_APP_DIR}/profiles"
WCS_DIR="/apps/wcs/CommerceServer80"
DMGR_PROF_NAME="Dmgr"
APP_PROF_NAME="BJSECOM"
SOLR_PORF_NAME="${APP_PROF_NAME}_solr"
DMGR_PROF_DIR="${PROFILES_DIR}/${DMGR_PROF_NAME}"
APP_PROF_DIR="${PROFILES_DIR}/${APP_PROF_NAME}"



if [ "${InputEnv}" = "qa" ]; then
   DB2_Server="UE02COMDBS01"
   DB_NAME="WCSSTG1"
   UE1_HOST_ALIAS="qa1-wcs-stage.bjs.com"
   UE2_HOST_ALIAS="qa1-wcs-stage-ue2.bjs.com"

elif [ "${InputEnv}" = "prod" ];then
   DB2_Server="UE02COMDBP02"
   DB_NAME="WCSPRD1"
   UE1_HOST_ALIAS="wcs.bjs.com"
   UE2_HOST_ALIAS="wcs-ue2.bjs.com"

elif [ "${InputEnv}" = "fullprod" ];then
   DB2_Server="UE02COMDBP02"
   DB_NAME="WCSPRD1"
   UE1_HOST_ALIAS="wcs.bjs.com"
   UE2_HOST_ALIAS="wcs-ue2.bjs.com"

elif [ "${InputEnv}" = "secondary" ];then
   DB2_Server="UE02COMDBP02"
   DB_NAME="WCSPRD1"
   UE1_HOST_ALIAS="wcs.bjs.com"
   UE2_HOST_ALIAS="wcs-ue2.bjs.com"

else
   echo "Wrong Environment selection"
fi


echo "DB2_Server = ${DB2_Server} , DB_NAME= ${DB_NAME} , UE1_HOST_ALIAS=${UE1_HOST_ALIAS} , UE2_HOST_ALIAS=${UE2_HOST_ALIAS}"

#Script Starts here >>




RC=$(hostname|grep -c ue02)

if [ "${RC}" = "1" -a  "${InputEnv}" = "qa" ];then
	echo "START QA DR Hostname Config "
  #/usr/local/script/System_ctl/WAS_App.sh stop
  #sleep 5
  changeHostname
  changeHostnameInFiles
  /apps/was/AppServer/profiles/Dmgr/bin/startManager.sh
  sleep 5
  #${SCRIPTS_DIR}/${InputEnv}/RemoveNodes.sh
	${APP_PROF_DIR}/bin/syncNode.sh ue02comaps01  8879
	cd /apps/was/AppServer/profiles/Dmgr/bin;
	./GenPluginCfg.sh -force yes -node.name WC_BJSECOM_node -webserver.name webserver1
	ls -lrt /apps/was/AppServer/profiles/Dmgr/config/cells/WC_BJSECOM_Cell/nodes/WC_BJSECOM_node/servers/webserver1/plugin-cfg.xml
	echo "Plugin Generated"
	scp -o StrictHostKeyChecking=no /apps/was/AppServer/profiles/Dmgr/config/cells/WC_BJSECOM_Cell/nodes/WC_BJSECOM_node/servers/webserver1/plugin-cfg.xml wcsadm@ue02comwbs01:/apps/Plugins/config/webserver1/plugin-cfg.xml
	db2 "uncatalog node DB2DRDB";
	db2 "uncatalog db ${DB_NAME}";
	db2 "catalog TCPIP NODE DB2DRDB REMOTE ${DB2_Server} SERVER 50000" ;
	db2 "catalog database ${DB_NAME} as ${DB_NAME} AT NODE DB2DRDB" ;
	db2 terminate ;
  /apps/wcs/CommerceServer80/bin/config_ant.sh -DinstanceName=BJSECOM UpdateEAR
  /usr/local/script/System_ctl/WAS_App.sh start
	echo "Configuring Web Server "
	ssh wcsadm@ue02comwbs01 'cd /scratch/DR_Scripts; ./webserverUpdateServername.sh qa '
	echo "DR Configurations for all Web Servers Done"

elif [ "${RC}" = "1" -a  "${InputEnv}" = "prod" ];then
	echo "START PROD DR Hostname Config for Single Server "
#        /usr/local/script/System_ctl/WAS_App.sh stop
#        sleep 5
  changeHostname
  changeHostnameInFiles
  /apps/was/AppServer/profiles/Dmgr/bin/startManager.sh
  sleep 5
  ${SCRIPTS_DIR}/${InputEnv}/RemoveNodes.sh
	${APP_PROF_DIR}/bin/syncNode.sh ue02comapp01  8879
	cd /apps/was/AppServer/profiles/Dmgr/bin;
	./GenPluginCfg.sh -force yes -node.name WC_BJSECOM_node -webserver.name webserver1
	ls -lrt /apps/was/AppServer/profiles/Dmgr/config/cells/WC_BJSECOM_Cell/nodes/WC_BJSECOM_node/servers/webserver1/plugin-cfg.xml
	echo "Plugin Generated"
	scp -o StrictHostKeyChecking=no /apps/was/AppServer/profiles/Dmgr/config/cells/WC_BJSECOM_Cell/nodes/WC_BJSECOM_node/servers/webserver1/plugin-cfg.xml wcsadm@ue02comwbp01:/apps/Plugins/config/webserver1/plugin-cfg.xml
	db2 "uncatalog node DB2DRDB";
	db2 "uncatalog db ${DB_NAME}";
	db2 "catalog TCPIP NODE DB2DRDB REMOTE ${DB2_Server} SERVER 50000" ;
	db2 "catalog database ${DB_NAME} as ${DB_NAME} AT NODE DB2DRDB" ;
	db2 terminate ;
  /apps/wcs/CommerceServer80/bin/config_ant.sh -DinstanceName=BJSECOM UpdateEAR
  ${SCRIPTS_DIR}/${InputEnv}/restart_script/mainscript_dr.sh
	echo "Configuring Web Server "
	ssh wcsadm@ue02comwbp01 'cd /scratch/DR_Scripts; ./webserverUpdateServername.sh prod '
	echo "DR Configurations for all Web Servers Done"

elif [ "${RC}" = "1" -a  "${InputEnv}" = "fullprod" ];then

  echo "START PROD DR Hostname Config for All Servers "
  #/usr/local/script/System_ctl/WAS_App.sh stop
  #sleep 5
  changeHostname
  changeHostnameInFilesFullProd
  /apps/was/AppServer/profiles/Dmgr/bin/startManager.sh
  sleep 5
	${APP_PROF_DIR}/bin/syncNode.sh ue02comapp01  8879
	cd /apps/was/AppServer/profiles/Dmgr/bin;
	./GenPluginCfg.sh -force yes -node.name ue00comwbp01_node  -webserver.name webserver1
	./GenPluginCfg.sh -force yes -node.name ue00comwbp02_node  -webserver.name webserver2
	./GenPluginCfg.sh -force yes -node.name ue00comwbp03_node  -webserver.name webserver3
	./GenPluginCfg.sh -force yes -node.name ue00comwbp04_node  -webserver.name webserver4

	echo "Plugin Generated"
	scp -o StrictHostKeyChecking=no /apps/was/AppServer/profiles/Dmgr/config/cells/WC_BJSECOM_Cell/nodes/ue00comwbp01_node/servers/webserver1/plugin-cfg.xml wcsadm@ue02comwbp01:/apps/Plugins/config/webserver1/plugin-cfg.xml
	scp -o StrictHostKeyChecking=no /apps/was/AppServer/profiles/Dmgr/config/cells/WC_BJSECOM_Cell/nodes/ue00comwbp02_node/servers/webserver2/plugin-cfg.xml wcsadm@ue02comwbp02:/apps/Plugins/config/webserver2/plugin-cfg.xml
	scp -o StrictHostKeyChecking=no /apps/was/AppServer/profiles/Dmgr/config/cells/WC_BJSECOM_Cell/nodes/ue00comwbp03_node/servers/webserver3/plugin-cfg.xml wcsadm@ue02comwbp03:/apps/Plugins/config/webserver3/plugin-cfg.xml
	scp -o StrictHostKeyChecking=no /apps/was/AppServer/profiles/Dmgr/config/cells/WC_BJSECOM_Cell/nodes/ue00comwbp04_node/servers/webserver4/plugin-cfg.xml wcsadm@ue02comwbp04:/apps/Plugins/config/webserver4/plugin-cfg.xml

	db2 "uncatalog node DB2DRDB";
	db2 "uncatalog db ${DB_NAME}";
	db2 "catalog TCPIP NODE DB2DRDB REMOTE ${DB2_Server} SERVER 50000" ;
	db2 "catalog database ${DB_NAME} as ${DB_NAME} AT NODE DB2DRDB" ;
	db2 terminate ;
  /apps/wcs/CommerceServer80/bin/config_ant.sh -DinstanceName=BJSECOM UpdateEAR
	echo "Configuring Web Server 1"
	ssh -o StrictHostKeyChecking=no wcsadm@ue02comwbp01 'cd /scratch/DR_Scripts; ./webserverUpdateServername.sh fullprod '
	echo "Configuring Web Server 2"
	ssh -o StrictHostKeyChecking=no wcsadm@ue02comwbp02 'cd /scratch/DR_Scripts; ./webserverUpdateServername.sh fullprod '
	echo "Configuring Web Server 3"
	ssh -o StrictHostKeyChecking=no  wcsadm@ue02comwbp03 'cd /scratch/DR_Scripts; ./webserverUpdateServername.sh fullprod '
	echo "Configuring Web Server 4"
	ssh -o StrictHostKeyChecking=no wcsadm@ue02comwbp04 'cd /scratch/DR_Scripts; ./webserverUpdateServername.sh fullprod '
	echo "DR Configurations for all Web Servers Done"
  ${SCRIPTS_DIR}/${InputEnv}/restart_script/mainscript_dr.sh

elif [ "${RC}" = "1" -a  "${InputEnv}" = "secondary" ];then
	echo "START PROD DR Hostname Config for Single Server "
#        /usr/local/script/System_ctl/WAS_App.sh stop
#        sleep 5
  changeHostname_s
  changeHostnameInFilesFullProd
	/scratch/restart_script/cleanstart_dr.sh

else
        echo "Wrong Environment! This Script is only for UE2 Region Environments"
        exit 1

fi

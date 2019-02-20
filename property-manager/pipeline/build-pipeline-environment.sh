UNIQUENAME=jgarza1-pipeline-backup
DEFDIR="/Users/jgarza/scratch/gss-clinic/pipeline"
ENVIRONMENTS="dev prod"
MYDOMAIN=gssclinic.world-tour.akamaideveloper.net
MYHOSTNAME=${UNIQUENAME}.${MYDOMAIN}
MYEDGEHOSTNAME=${MYDOMAIN}.edgesuite.net
MYEDGEHOSTNAMEID=3392472 
CLOUDSTORAGE=s3.amazonaws.com
APISERVER=origin-api.urbancrawlapp.com
WEBSERVER=origin-web.urbancrawlapp.com

function backup-file {
	# Backup original file 
	if [ ! -f $1-original ]; then 
		cp -p $1 $1-original
	fi
}

# Change to the pipeline default directory (git)
if [ -d ${DEFDIR} ] ; then
	cd $DEFDIR
else
	echo "ERROR: $DEFDIR directory doesn't exist"
	exit 1
fi

# Create pipeline if it doesn't exist already
if [ ! -d ${DEFDIR}/${UNIQUENAME} ] ; then
	akamai pipeline new-pipeline --pipeline ${UNIQUENAME} --propertyId ${UNIQUENAME} $ENVIRONMENTS
fi

# set default pipeline
akamai pipeline set-default --pipeline ${UNIQUENAME}

# Set file to edit and make a backup copy before editing
MYFILE="${UNIQUENAME}/environments/variableDefinitions.json"
backup-file ${MYFILE}

# edit file using jq
jq ".definitions.originAPIHostname.type = \"hostname\" | .definitions.originImagesHostname.type = \"hostname\" | .definitions.bucket.type = \"bucket\" | .definitions.originImagesHostname.default = \"${CLOUDSTORAGE}\"| .definitions.cpCode.default = 749512 | .definitions.bucket.default = null |.definitions.originAPIHostname.default = null" ${MYFILE}-original > ${MYFILE}

for MYENV in $ENVIRONMENTS ; 
do
	# Set file to edit and make a backup copy before editing
	MYFILE="${UNIQUENAME}/environments/${MYENV}/hostnames.json"
	backup-file ${MYFILE}

	# edit file using jq
	jq ".[].cnameFrom = \"${MYENV}.${UNIQUENAME}.${MYDOMAIN}\" | .[].cnameTo = \"$MYEDGEHOSTNAME\" | .[].edgeHostnameId = $MYEDGEHOSTNAMEID" ${MYFILE}-original > ${MYFILE}

	# Set file to edit and make a backup copy before editing
	MYFILE="${UNIQUENAME}/environments/${MYENV}/variables.json"
	backup-file ${MYFILE}

	# edit file using jq
	jq ".originHostname = \"${MYENV}-$WEBSERVER\" | .originImagesHostname = null | .bucket = \"${MYENV}-${UNIQUENAME}\" | .originAPIHostname = \"${MYENV}-$APISERVER\" " ${MYFILE}-original > ${MYFILE}
done

# Set file to edit and make a backup copy before editing
MYFILE="${UNIQUENAME}/templates/API.json"
backup-file ${MYFILE}

# edit file using jq
jq ".behaviors[0].options.hostname = \"\${env.originAPIHostname}\" " ${MYFILE}-original > ${MYFILE}

# Set file to edit and make a backup copy before editing
MYFILE="${UNIQUENAME}/templates/Images.json"
backup-file ${MYFILE}

jq ".behaviors[0].options.hostname = \"\${env.originImagesHostname}\" " ${MYFILE}-original > ${MYFILE}

# Set file to edit and make a backup copy before editing
MYFILE="${UNIQUENAME}/templates/main.json"
backup-file ${MYFILE}

jq " .rules.behaviors += [{\"name\": \"allowDelete\",\"options\": {\"enabled\": true } } ] " ${MYFILE}-original > ${MYFILE}

echo -e "\nEverything looks good, to promote your changes to staging you can run:\nakamai pipeline promote [dev|prod] --network staging --emails [email address]\nAfterwards you can check status using:\nakamai pd check-promotion-status [dev|prod]"
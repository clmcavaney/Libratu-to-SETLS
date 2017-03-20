#!/usr/bin/env bash

#
# Description: Script to take hashed image file name references and change them to
#              names that match the code of the toy.
#              Some EXIF metadata is also added
#              e.g. ie03sUBEApqr.jpg --> 816.jpg
# Written by: Christopher McAvaney - christopher.mcavaney@gmail.com
# 

# Location of the folder with a Libraru backup ZIP file extracted
BACKUP_FOLDER="backup-20151206"
BACKUP_FOLDER="backup-20160215"
BACKUP_XML_FILE=${BACKUP_FOLDER}/data.xml
# Location of the folder to place the renamed image files
NEW_IMAGE_FOLDER="toy-images-20160215"

# Traverse the XML to find the toys branch
NUM_TOYS=$(xmllint --xpath "count(/libratu/data/toys/toy)" ${BACKUP_XML_FILE})
echo "num toys == ${NUM_TOYS}"
for ((cnt = 1; cnt <= NUM_TOYS; cnt++)) ; do
	IMAGE_FILE=""

	TOY_ID=$(xmllint --xpath "string(/libratu/data/toys/toy[$cnt]/@id)" ${BACKUP_XML_FILE})
	TOY_CODE=$(xmllint --xpath "string(/libratu/data/toys/toy[$cnt]/code)" ${BACKUP_XML_FILE})
	TOY_NAME=$(xmllint --xpath "string(/libratu/data/toys/toy[$cnt]/name)" ${BACKUP_XML_FILE})
	echo "Toy: ${TOY_CODE} (${TOY_ID}) \"${TOY_NAME}\""

	# check for an image file
	IMAGE_FILE=$(xmllint --xpath "string(/libratu/data/toys/toy[$cnt]/image-filename)" ${BACKUP_XML_FILE})
	if [ -n "${IMAGE_FILE}" ] ; then
		echo "backup image file == ${IMAGE_FILE}"
		if [ -a ${BACKUP_FOLDER}/${IMAGE_FILE} ] ; then
			echo "creating copy"
			cp -av ${BACKUP_FOLDER}/${IMAGE_FILE} ${NEW_IMAGE_FOLDER}/${TOY_CODE}.jpg
			# Add the EXIF metadata to the new image
			exiftool -creator="Belmont Toy Library" -title="${TOY_NAME}" ${NEW_IMAGE_FOLDER}/${TOY_CODE}.jpg
		fi
	else
		echo "no image file"
	fi
done

# END OF FILE

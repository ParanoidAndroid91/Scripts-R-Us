#!/bin/bash

# Auto-Sign Scripts (ASS)
# Written by Luke X, 03rd August 2020

# TEST BEFORE USE - NO LIABILITY NOR WARRANTY IMPLIED NOR GIVEN

###########################################################################
#                   ENSURE THE FOLLOWING BEFORE RUNNING                   #                             
#	1. The script is saved in ~/Desktop/FakeRoot/Library/Scripts          #
#	2. You have both Apple Developer certificates installed               #
###########################################################################

# Set Variables (modify these as appropriate, the certificate names need to be completed to match your own)
scriptPath="~/Desktop/FakeRoot/Library/Scripts/scriptName.sh"
packageName="somePackage"
applicationCertificate="Developer ID Application: "
installerCertificate="Developer ID Installer: "
bundleID="com.orgName.something"

# Set permissions and ownership for script
sudo chmod 755 $scriptPath
sudo chown root:wheel $scriptPath
echo "Permissions and ownership set"

# Sign script
codesign -s "$applicationCertificate" -i $bundleID $scriptPath

# Confirm extended attributes are present
exAttr=$(xattr $scriptPath | grep -w "com.apple.cs.CodeRequirements-1")
if [[ $exAttr == "com.apple.cs.CodeRequirements-1" ]]; then
	echo "Extended attributes set"
else 
	echo "Extended attributes not set"
	exit 1
fi

# Build signed PKG and place on Desktop
pkgbuild --root ~/Desktop/FakeRoot --identifier $bundleID --sign "$installerCertificate" ~/Desktop/$packageName.pkg --preserve-xattr
echo "Signed package built successfully"

exit 0
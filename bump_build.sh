#!/usr/bin/env bash
buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$1")
buildNumber=$(($buildNumber + 1))
echo Incremented build number to $buildNumber
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "$1"

#!/bin/sh

# Clean to install - "with administrator privileges" brings up the login prompt
osascript -e "do shell script \" \
	rm -rf /Applications/Xcode.app/Contents/Developer/Library/Frameworks/ShinobiCharts.framework \
	rm -rf $HOME/Library/Developer/Shared/Documentation/DocSets/com.scottlogic.ShinobiCharts.docset\" \
with administrator privileges"

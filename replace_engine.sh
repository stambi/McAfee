#!/bin/bash
######
#24.04.2017 / STA
#Replace McAfee 5800 Engine with 5900 Engine
######
workingdir=tmp
runtime=$(date)
current_version=$(sudo defaults read /Library/Preferences/com.mcafee.ssm.antimalware.plist Update_EngineVersion | cut -d . -f 1)

if [ "$current_version" = "5900" ]; then
  echo "$runtime" >> /tmp/replace_engine.log
  echo "AVEngine is already 5900" >> /tmp/replace_engine.log
  exit 0
fi

rm -rf /tmp/epo5900mub

cd "$workingdir"
unzip $workingdir/epo5900mub.zip -d epo5900mub
unzip $workingdir/epo5900mub/avengine.zip -avengine

#unload old AVEngine
sudo launchctl unload  /Library/LaunchDaemons/com.mcafee.ssm.ScanManager.plist
sudo launchctl unload /Library/LaunchDaemons/com.mcafee.ssm.ScanFactory.plist

#remove old AVEngine Framework
rm -rf /Library/Frameworks/AVEngine.framework

#copy new AVEngine
cp -r $workingdir/epo5900mub/avengine/AVEngine.framework /Library/Frameworks/
cd /Library/Frameworks/
chown root:wheel AVEngine.framework
chmod 755 AVEngine.framework

#add new version to the plist file
sudo defaults write /Library/Preferences/com.mcafee.ssm.antimalware.plist Update_EngineVersion -string 5900.7806

#reload AVEngine
sudo launchctl load  /Library/LaunchDaemons/com.mcafee.ssm.ScanManager.plist
sudo launchctl load  /Library/LaunchDaemons/com.mcafee.ssm.ScanFactory.plist







# rm -rf /tmp/epo5900mub.*

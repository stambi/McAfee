#!/bin/bash
######
#24.04.2017 / STA
#Replace McAfee 5800 Engine with 5900 Engine
######

workingdir=/tmp
runtime=$(date)
current_version=$(sudo defaults read /Library/Preferences/com.mcafee.ssm.antimalware.plist Update_EngineVersion | cut -d . -f 1)
#hier allenfalls noch eine if Abfrage “McAffe installiert”

if [ "$current_version" = "5900" ]; then
  echo "$runtime" >> /tmp/replace_engine.log
  echo "AVEngine is already 5900" >> /tmp/replace_engine.log
  exit 0
fi

sleep 10
rm -rf /tmp/epo5900mub
cd "$workingdir"
unzip $workingdir/epo5900mub.zip -d epo5900mub
unzip $workingdir/epo5900mub/avengine.zip -d epo5900mub/avengine
echo "$runtime" >> /tmp/replace_engine.log
echo "unzip OK" >> /tmp/replace_engine.log

sleep 10
#unload old AVEngine
sudo launchctl unload  /Library/LaunchDaemons/com.mcafee.ssm.ScanManager.plist
sudo launchctl unload /Library/LaunchDaemons/com.mcafee.ssm.ScanFactory.plist
echo "$runtime" >> /tmp/replace_engine.log
echo "unload OK" >> /tmp/replace_engine.log

sleep 10
#remove old AVEngine Framework
rm -rf /Library/Frameworks/AVEngine.framework
echo "$runtime" >> /tmp/replace_engine.log
echo "delete old AVEngine Framework OK" >> /tmp/replace_engine.log

sleep 10
#copy new AVEngine
cp -r $workingdir/epo5900mub/avengine/AVEngine.framework /Library/Frameworks/
cd /Library/Frameworks/
chown root:wheel AVEngine.framework
chmod 755 AVEngine.framework
echo "$runtime" >> /tmp/replace_engine.log
echo "copy new AVEngine Framework OK" >> /tmp/replace_engine.log

<<<<<<< HEAD
sleep 10
#add new version to the plist file (noch abklären ob das die richtige Version ist, habe ich im Netz nirgends gefunden, alte Version war 5800.7501)
sudo defaults write /Library/Preferences/com.mcafee.ssm.antimalware.plist Update_EngineVersion -string 5900.7806
echo "$runtime" >> /tmp/replace_engine.log
echo "add new Version to plist OK" >> /tmp/replace_engine.log
=======
#add new version to the plist file
sudo defaults write /Library/Preferences/com.mcafee.ssm.antimalware.plist Update_EngineVersion -string 5900.7806
>>>>>>> origin/master

sleep 10
#reload AVEngine
sudo launchctl load  /Library/LaunchDaemons/com.mcafee.ssm.ScanManager.plist
sudo launchctl load  /Library/LaunchDaemons/com.mcafee.ssm.ScanFactory.plist
echo "$runtime" >> /tmp/replace_engine.log
echo "reload AVEngine OK" >> /tmp/replace_engine.log
echo "#########done#########" >> /tmp/replace_engine.log




# rm -rf /tmp/epo5900mub.*

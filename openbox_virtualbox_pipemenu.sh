#!/bin/bash
#       openbox_virtualbox_pipemenu.sh
#       initially created 2014 - Ryan Fantus
#
# assumes your virtualbox file is ~/.config/VirtualBox/VirtualBox.xml and 
# your virtualbox binary is /usr/bin/virtualbox
# IMPORTANT!!! VirtualBox by default stores vbox drives in ~/VirtualBox VMs
#   - If yours is in a different location, sorry...this won't work for you!

vbox_launcher=/usr/bin/virtualbox
vbox_xml=~/.config/VirtualBox/VirtualBox.xml

function generate_vbox_menu {

  # read each line of vbox_xml
  while read line
  do
        # test if it is a MachineEntry
        if [[ $line == "<MachineEntry"* ]]; then
                echo -n '<item label="'
                # ungracefully extract the name of the VM
                vbox_description=`echo $line | sed -n "s/.*\(VMs.*vbox\).*/\1/p" | awk -F/ '{print $NF}' | sed -e 's/.vbox//g'`
                echo -n $vbox_description
                echo '">'
                echo -n '<action name="Execute"><execute>'
                echo -n "$vbox_launcher --startvm "
                # extract the UUID to launch
                launch_uuid=`echo $line | sed -e 's/.*{\([^}]\+\)}.*/\1/g'`
                echo -n $launch_uuid
                echo '</execute></action>'
                echo '</item>'
        fi
  done < $vbox_xml

}

echo '<openbox_pipe_menu>'

# First, we'll create a launcher specifically for VirtualBox

echo '<item label="VirtualBox">'
echo -n '<action name="Execute"><execute>'
echo -n "$vbox_launcher"
echo '</execute></action>'
echo '</item>'
echo '<separator/>'

generate_vbox_menu

echo '</openbox_pipe_menu>'

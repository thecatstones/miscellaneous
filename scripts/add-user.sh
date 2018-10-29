# I realize this is a bit late, but I had the same problem and managed to solve it. Here are the set of commands that you need to run as root on a new digital ocean droplet (assuming you have already setup root to have ssh access). This will setup "$1" with passwordless sudo rights and the ability to ssh into the machine without a password (using only your ssh-key)

adduser --system --group "$1"
mkdir /home/"$1"/.ssh
chmod 0700 /home/"$1"/.ssh/
cp -Rfv /root/.ssh /home/"$1"/
chown -Rfv "$1"."$1" /home/"$1"/.ssh
chown -R "$1":"$1" /home/"$1"/
gpasswd -a "$1" sudo
echo ""$1" ALL=(ALL) NOPASSWD: ALL" | (EDITOR="tee -a" visudo)
service ssh restart
usermod -s /bin/bash "$1"

# Now you should be able to ssh into your new droplet with
# ssh "$1"@your-new-digitalocean-droplet-ip-address

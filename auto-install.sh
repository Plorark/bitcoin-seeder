#!/bin/bash
RED='\033[0;31m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

if [ "$EUID" -ne 0 ]
  then printf "${RED}Please run this script with sudo${NC}\n"
  exit
fi

printf "${RED}
  (((((((((((((((((((((((((((  
  ((           ((        ((((  
  ((         (((        (((((  
  ((       (((        (((((((  
  ((     (((        (((((((((  
  ((   (((        (((((((((((  
  ((  ((((        (((((((((((  
  (((((  (((        (((((((((  
  (((      (((        (((((((  
  ((         (((        (((((  
  ((           ((         (((  
  (((((((((((((((((((((((((((   
${NC}"


AGAIN=true


printf "\nWelcome to the ${RED}Kore Seeder${NC}... uh... oh, yeah, installer tool.\n"
sleep 1
printf "Wow, very cool, such awesome, much easy, many nice\n\n"

while [ "$AGAIN" = true ]
do
   sleep 1
  printf "Ok, what is your ${CYAN}dnsseed address?${NC} (like dnsseed.kore.life)\n"
  read dnsseeduri
  printf "Wow, very creative name.\n"
  sleep 1
  printf "\nOk, what about the ${CYAN}name server${NC}? (probably ${RED}${dnsseeduri}${NC} without the first part)\n"
  read nsuri

  printf "Wow, what a surprise.\n"
  sleep 1
  printf "\nSo ${RED}${dnsseeduri}${NC} for the ${CYAN}dnsseed address${NC} and ${RED}${nsuri}${NC} for the ${CYAN}ns address${NC}, right?\n"

  while true; do
      read -p "(Yes/No/Cancel)" yn
      case $yn in
          [Yy]* ) AGAIN=false; break;;
          [Nn]* ) printf "\nWell... Here we go again...\n\n"; break;;
          [Cc]* ) exit;;
          * ) echo "Please answer yes or no.";
      esac
  done

done


printf "Finally...\n"
sleep 1
printf "\nOk, so let's start...\n\n"

printf "${RED}I\'ll install the dependencies (tor and compilation tools).\n(˵ ͡° ͜ʖ ͡°˵) Please look away ${NC} \n"

echo "deb https://deb.torproject.org/torproject.org xenial main" | sudo tee -a /etc/apt/sources.list
echo "deb-src https://deb.torproject.org/torproject.org xenial main" | sudo tee -a /etc/apt/sources.list

gpg --keyserver keys.gnupg.net --recv A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -

apt-get update && apt-get upgrade -y &&

sudo apt-get install git -y &&
sudo apt-get install build-essential libboost-all-dev libssl-dev -y &&
sudo apt-get install tor deb.torproject.org-keyring -y &&

localrepo=$(basename `git rev-parse --show-toplevel`)
if ! [ "$localrepo" = "kore-seeder" ] ; then
   printf "${RED}\n\nInstalled. I'll clone the seeder from github now.${NC}\n"
   git clone https://github.com/Plorark/kore-seeder.git
fi

printf "${RED}\n\nDone. Let's compile everything.${NC}\n"
sudo chmod 777 ./kore-seeder
cd kore-seeder
make

printf "${RED}\n\nCompiled!${NC}\n"
sleep 1
printf "${RED}\n\nAdding a shortcut (with some params) for future runnings...${NC}\n"
sleep 1
sudo printf "dnsseed -h ${dnsseeduri} -n ${nsuri} -m avoidwarningemail.kore.life -o 127.0.0.1:9050 -i 127.0.0.1:9050 -k 127.0.0.1:9050 -p 5353 &" >> run-kore-seeder
sudo chmod 777 ./run-kore-seeder
printf "${RED}\n\nShortcut added${NC}\n"

sleep 1
printf "${RED}\n\nUsually the seeder needs to run as SU (since only SUs can access port 53).${NC}\n"
printf "${RED}But I'll help you out on this.${NC}\n"
sleep 1
iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-port 5353
printf "${RED}\nDone, now you can run it on port 5353.${NC}\n"
printf "${RED}You're welcome.${NC}\n"
sleep 1

printf "${RED}\n\nAdding this folder to your PATH${NC}\n"
echo "export PATH=$PWD:\$PATH" >> /root/.bashrc
sudo source ~/.bashrc

printf "${RED}\n\nAnd finally, let's run it!!!!!!!!${NC}\n"
./run-kore-seeder
printf "\n\nOkay. Done. Bye.\n"
exit

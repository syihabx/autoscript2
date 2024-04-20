NC='\e[0m'
DEFBOLD='\e[39;1m'
RB='\e[31;1m'
GB='\e[32;1m'
YB='\e[33;1m'
BB='\e[34;1m'
MB='\e[35;1m'
CB='\e[35;1m'
WB='\e[37;1m'
clear
echo -e "${GB}[ INFO ]${NC} ${YB}Start${NC} "
sleep 0.5
systemctl stop nginx
domain=$(cat /var/lib/dnsvps.conf | cut -d'=' -f2)
CF_GlobalKey=""
CF_AccountEmail=""
echo -e "Please set the API key:"
read -p "Input your key here:" CF_GlobalKey
echo -e "Your API key is:${CF_GlobalKey}"
echo -e "Please set up registered email:"
read -p "Input your email here:" CF_AccountEmail
echo -e "Your registered email address is:${CF_AccountEmail}"
Cek=$(lsof -i:80 | cut -d' ' -f1 | awk 'NR==2 {print $1}')
if [[ ! -z "$Cek" ]]; then
sleep 1
echo -e "${RB}[ WARNING ]${NC} ${YB}Detected port 80 used by $Cek${NC} "
systemctl stop $Cek
sleep 2
echo -e "${GB}[ INFO ]${NC} ${YB}Processing to stop $Cek${NC} "
sleep 1
fi
echo -e "${GB}[ INFO ]${NC} ${YB}Starting renew cert...${NC} "
sleep 2
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
if [ $? -ne 0 ]; then
    echo -e "Default CA, Lets'Encrypt fail, script exiting..."
    exit 1
fi
export CF_Key="${CF_GlobalKey}"
export CF_Email=${CF_AccountEmail}
cd .acme.sh
cd .acme.sh
bash acme.sh --issue --dns dns_cf -d $domain --keylength ec-256 --fullchain-file /usr/local/etc/xray/fullchain.crt --key-file /usr/local/etc/xray/private.key --standalone --force
echo -e "${GB}[ INFO ]${NC} ${YB}Renew cert done...${NC} "
sleep 2
echo -e "${GB}[ INFO ]${NC} ${YB}Starting service $Cek${NC} "
sleep 2
echo "$domain" > /usr/local/etc/xray/domain
systemctl restart $Cek
systemctl restart nginx
echo -e "${GB}[ INFO ]${NC} ${YB}All finished...${NC} "
sleep 0.5
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
menu

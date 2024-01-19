NC='\e[0m'
DEFBOLD='\e[39;1m'
RB='\e[31;1m'
GB='\e[32;1m'
YB='\e[33;1m'
BB='\e[34;1m'
MB='\e[35;1m'
CB='\e[35;1m'
WB='\e[37;1m'
xray_service=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
nginx_service=$(systemctl status nginx | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $xray_service == "running" ]]; then
status_xray="${GB}[ ON ]${NC}"
else
status_xray="${RB}[ OFF ]${NC}"
fi
if [[ $nginx_service == "running" ]]; then
status_nginx="${GB}[ ON ]${NC}"
else
status_nginx="${RB}[ OFF ]${NC}"
fi
dtoday="$(vnstat | grep today | awk '{print $2" "substr ($3, 1, 3)}')"
utoday="$(vnstat | grep today | awk '{print $5" "substr ($6, 1, 3)}')"
ttoday="$(vnstat | grep today | awk '{print $8" "substr ($9, 1, 3)}')"
dmon="$(vnstat -m | grep `date +%G-%m` | awk '{print $2" "substr ($3, 1 ,3)}')"
umon="$(vnstat -m | grep `date +%G-%m` | awk '{print $5" "substr ($6, 1 ,3)}')"
tmon="$(vnstat -m | grep `date +%G-%m` | awk '{print $8" "substr ($9, 1 ,3)}')"
domain=$(cat /usr/local/etc/xray/domain)
ISP=$(cat /usr/local/etc/xray/org)
CITY=$(cat /usr/local/etc/xray/city)
WKT=$(cat /usr/local/etc/xray/timezone)
DATE=$(date -R | cut -d " " -f -4)
MYIP=$(curl -sS ipv4.icanhazip.com)
clear
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e "               ${WB}----- [ Xray Script ] -----${NC}              "
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e " ${YB}Service Provider${NC} ${WB}: $ISP"
echo -e " ${YB}Timezone${NC}         ${WB}: $WKT${NC}"
echo -e " ${YB}City${NC}             ${WB}: $CITY${NC}"
echo -e " ${YB}Date${NC}             ${WB}: $DATE${NC}"
echo -e " ${YB}Domain${NC}           ${WB}: $domain${NC}"
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e "     ${WB}NGINX STATUS :${NC} $status_nginx    ${WB}XRAY STATUS :${NC} $status_xray   "
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e "          ${WB}----- [ Bandwidth Monitoring ] -----${NC}"
echo -e ""
echo -e "  ${GB}Today ($DATE)     Monthly ($(date +%B/%Y))${NC}      "
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e "    ${GB}↓↓ Down: $dtoday          ↓↓ Down: $dmon${NC}   "
echo -e "    ${GB}↑↑ Up  : $utoday          ↑↑ Up  : $umon${NC}   "
echo -e "    ${GB}≈ Total: $ttoday          ≈ Total: $tmon${NC}   "
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e "                ${WB}----- [ Xray Menu ] -----${NC}               "
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e " ${MB}[1]${NC} ${YB}Vmess Menu${NC}          ${MB}[5]${NC} ${YB}Shadowsocks 2022 Menu${NC}"
echo -e " ${MB}[2]${NC} ${YB}Vless Menu${NC}          ${MB}[6]${NC} ${YB}All Xray Menu${NC}"
echo -e " ${MB}[3]${NC} ${YB}Trojan Menu${NC}"
echo -e " ${MB}[4]${NC} ${YB}Shadowsocks Menu${NC}"
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e "                 ${WB}----- [ Utility ] -----${NC}                "
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e " ${MB}[7]${NC} ${YB}Log Create Account${NC}  ${MB}[12]${NC} ${YB}Delete Script${NC}"
echo -e " ${MB}[8]${NC} ${YB}Speedtest${NC}           ${MB}[13]${NC}
${YB}Reinstall Script${NC}"
echo -e " ${MB}[9]${NC} ${YB}Change Domain${NC}"
echo -e " ${MB}[10]${NC} ${YB}Cert Acme.sh${NC}"
echo -e " ${MB}[11]${NC} ${YB}About Script${NC}"
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e ""
read -p " Select Menu :  "  opt
echo -e ""
case $opt in
1) clear ; vmess ;;
2) clear ; vless ;;
3) clear ; trojan ;;
4) clear ; shadowsocks ;;
5) clear ; ss2022 ;;
6) clear ; allxray ;;
7) clear ; log-create ;;
8) clear ; speedtest ; echo " " ; read -n 1 -s -r -p "Press any key to back on menu" ; menu ;;
9) clear ; dns ;;
10) clear ; certxray ;;
11) clear ; about ;;
12) clear ;
rm -rf /user >> /dev/null 2>&1
rm -rf /tmp >> /dev/null 2>&1
rm /usr/local/etc/xray/city >> /dev/null 2>&1
rm /usr/local/etc/xray/org >> /dev/null 2>&1
rm /usr/local/etc/xray/timezone >> /dev/null 2>&1
rm -rf /var/www/html/vmess >> /dev/null 2>&1
rm -rf /var/www/html/vless >> /dev/null 2>&1
rm -rf /var/www/html/trojan >> /dev/null 2>&1
rm -rf /var/www/html/ss >> /dev/null 2>&1
rm -rf /var/www/html/ss2022 >> /dev/null 2>&1
rm -rf /var/www/html/allxray >> /dev/null 2>&1
sudo systemctl stop nginx
sudo apt-get remove --purge nginx
sudo rm -rf /etc/nginx >> /dev/null 2>&1
sudo rm -rf /var/log/nginx >> /dev/null 2>&1
bash -c "$(curl -L
https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ remove --purge
rm -rf /var/log/xray >> /dev/null 2>&1
rm -rf /usr/local/etc/xray >> /dev/null 2>&1
rm -rf ~/.acme.sh >> /dev/null 2>&1
sudo apt-get autoremove
cd /usr/bin
rm -rf add-vmess
rm -rf del-vmess
rm -rf extend-vmess
rm -rf trialvmess
rm -rf cek-vmess
rm -rf add-vless
rm -rf del-vless
rm -rf extend-vless
rm -rf trialvless
rm -rf cek-vless
rm -rf add-trojan
rm -rf del-trojan
rm -rf extend-trojan
rm -rf trialtrojan
rm -rf cek-trojan
rm -rf add-ss
rm -rf del-ss
rm -rf extend-ss
rm -rf trialss
rm -rf cek-ss
rm -rf add-ss2022
rm -rf del-ss2022
rm -rf extend-ss2022
rm -rf trialss2022
rm -rf cek-ss2022
rm -rf add-xray
rm -rf del-xray
rm -rf extend-xray
rm -rf trialxray
rm -rf cek-xray
rm -rf log-create
rm -rf log-vmess
rm -rf log-vless
rm -rf log-trojan
rm -rf log-ss
rm -rf log-ss2022
rm -rf log-allxray
rm -rf menu
rm -rf vmess
rm -rf vless
rm -rf trojan
rm -rf shadowsocks
rm -rf ss2022
rm -rf allxray
rm -rf xp
rm -rf dns
rm -rf certxray
rm -rf about
rm -rf clear-log
rm -rf changer
cd

sudo sed -i '/0 0 \* \* \* \* root xp/d' /etc/crontab
sudo sed -i '/5\/5 \* \* \* \* root clear-log/d' /etc/crontab

cat > /root/.profile << END
if [ "$BASH" ]; then
if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi
fi
mesg n || true
END
chmod 644 /root/.profile
; echo -e "${YB}Script Deleted${NC}" ;;
13) clear ; 
echo -e "${YB}[ WARNING ] All users will be deleted (Y/N)${NC} "
read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
exit 0
else
bash -c "$(wget -qO- s.id/20rns)"
fi
;;
x) exit ;;
*) echo -e "${YB}salah input${NC}" ; sleep 1 ; menu ;;
esac

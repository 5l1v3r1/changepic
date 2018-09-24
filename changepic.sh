#!/bin/bash
# ChangePic v1.0
# Instagram Profile Pic Changer, author: github.com/thelinuxchoice


csrftoken=$(curl https://www.instagram.com/accounts/login/ajax -L -i -s | grep "csrftoken" | cut -d "=" -f2 | cut -d ";" -f1)
login_user() {

if [[ "$default_username" == "" ]]; then
read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Login: \e[0m' username
else
username="${username:-${default_username}}"
fi

if [[ "$default_password" == "" ]]; then
IFS=$'\n'
read -s -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Password: \e[0m' password
else
password="${password:-${default_password}}"
fi

printf "\e[\n1;77m[*] Trying to login as\e[0m\e[1;77m %s\e[0m\n" $username

IFS=$'\n'
check_login=$(curl -c cookies.txt 'https://www.instagram.com/accounts/login/ajax/' -H 'Cookie: csrftoken='$csrftoken'' -H 'X-Instagram-AJAX: 1' -H 'Referer: https://www.instagram.com/' -H 'X-CSRFToken:'$csrftoken'' -H 'X-Requested-With: XMLHttpRequest' --data 'username='$username'&password='$password'&intent' -L --compressed -s | grep -o '"authenticated": true')
echo $check_login
if [[ "$check_login" == *'"authenticated": true'* ]]; then
printf "\e[1;92m[*] Login Successful!\e[0m\n"
else
printf "\e[1;93m[!] Check your login data or IP! Dont use Tor, VPN, Proxy. It requires your usual IP.\n\e[0m"

login_user
fi

}

change_picture() {

read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Profile jpg file: \e[0m' path_pic

if [[ ! -e $path_pic ]]; then
printf "\e[1;93m [!] File not found\e[0m"
exit 1
else
if [[ ! $path_pic == *".jpg" ]]; then
printf "\e[1;93m[!] invalid format. Use jpg file\e[0m"
exit 1
else


curl -b cookies.txt 'https://www.instagram.com/accounts/web_change_profile_picture/' -H 'origin: https://www.instagram.com' -H 'accept-encoding: gzip, deflate, br' -H 'accept-language: pl-PL,pl;q=0.8,en-US;q=0.6,en;q=0.4' -H 'x-requested-with: XMLHttpRequest' -H 'cookie:  csrftoken='$csrftoken';' -H 'x-csrftoken: '$csrftoken'' -H 'pragma: no-cache' -H 'x-instagram-ajax: 1' -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36' -H 'content-type: multipart/form-data; boundary=----WebKitFormBoundarycqpuFD4uRAhkxVFt' -H 'accept: */*' -H 'cache-control: no-cache' -H 'authority: www.instagram.com' -H 'referer: https://www.instagram.com/'$username'' --compressed -F 'profile_pic=@'$path_pic'' 
fi
fi
}

login_user
change_picture

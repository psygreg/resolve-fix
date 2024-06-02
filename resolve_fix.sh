#!/bin/sh
#FUNCTIONS
#yay check
yay_func() {
	if pacman -Qs yay > /dev/null; then
        echo "YAY already installed, proceeding..."
    else
        cd && pacman -S --needed --noconfirm git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si && cd && rm -r ~/yay
    fi
}
#yay package patch - unknown symbol fix
symbol_fix() {
	yay -S --needed --noconfirm davinci-resolve-studio
    sudo mkdir /opt/resolve/libs/disabled
    sudo mv /opt/resolve/libs/libgmodule-2.0.so* /opt/resolve/libs/disabled/
    sudo mv /opt/resolve/libs/libgio-2.0.so* /opt/resolve/libs/disabled/
    sudo mv /opt/resolve/libs/libglib-2.0.so* /opt/resolve/libs/disabled/
}
#hybrid gpu setup fix
hybrid_fix() {
	gpu=$(lspci | grep -i '.* vga .* nvidia .*')
    shopt -s nocasematch
    if [[ $gpu == *' nvidia '* ]]; then
        gpus=$(lspci | grep VGA | wc -l)
        if [ "$gpus" -gt 1 ]; then
            sudo sed -i 's|^Exec=/opt/resolve/bin/resolve %u$|Exec=prime-run /opt/resolve/bin/resolve %u|' /usr/share/applications/DaVinciResolve.desktop
        else
            echo "No Nvidia PRIME setup detected, skipping..."
        fi
    else
        echo "No Nvidia GPU detected."
    fi
}
#get language from OS
get_lang() {
    local lang="${LANG:0:2}"
    local available=("pt" "en")

    if [[ " ${available[*]} " == *"$lang"* ]]; then
        ulang="$lang"
    else
        ulang="en"
    fi
    }
##SCRIPT RUN START
#check if OS is arch-based by looking for pacman
if command -v pacman &> /dev/null; then
    echo "Pacman detected. Starting..."
else
    echo "Pacman not detected."
    exit 1
fi
#get language
get_lang
#en-US
if [ "$ulang" == "en" ]; then
    echo "This is the *resolve-fix* shell script by Psygreg.";
    echo "It will download and install DaVinci Resolve Studio and its dependencies from the AUR and apply a patch to a common 'undefined symbol' error.";
    echo "Proceed?";
    select yn in "Yes" "No"; do
        case $yn in
            Yes )
                yay_check;
                symbol_fix;
                hybrid_fix;
                echo "Job finished. You may use DaVinci Resolve Studio now. It will take some time to load the Fairlight Engine for the first time, but it's not frozen. Be patient!";
                exit 0;;
            No )
                echo "Operation cancelled.";
                exit 0;;
        esac
    done
elif [ "$ulang" == "pt" ]; then
    echo "Este é o script *resolve-fix* por Psygreg."
    echo "Ele irá baixar e instalar o DaVinci Resolve Studio e suas dependências a partir do AUR e aplicar uma correção para um erro comum 'undefined symbol'."
    echo "Prosseguir?"
    select sn in "Sim" "Não"; do
        case $sn in
            Sim )
                yay_check;
                symbol_fix;
                hybrid_fix;
                echo "Concluído. Você pode utilizar o seu software agora. Ele levará algum tempo para iniciar o Fairlight Engine pela primeira vez, mas não estará travado, então seja paciente!";
                exit 0;;
            Não )
                echo "Operação cancelada.";
                exit 0;;
        esac
    done
fi

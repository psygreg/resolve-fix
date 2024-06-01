#!/bin/sh
echo "Language:"
select lang in "en-US" "pt-BR"; do
  case $lang in
    en-US )
      echo "This is the *resolve-fix* shell script by Psygreg.";
      echo "It will download and install DaVinci Resolve Studio and its dependencies from the AUR and apply a patch to a common 'undefined symbol' error.";
      echo "Proceed?";
      select yn in "Yes" "No"; do
        case $yn in
          Yes )
            yay -S --needed --noconfirm davinci-resolve-studio;
            sudo mkdir /opt/resolve/libs/disabled;
            sudo mv /opt/resolve/libs/libgmodule-2.0.so* /opt/resolve/libs/disabled/;
            sudo mv /opt/resolve/libs/libgio-2.0.so* /opt/resolve/libs/disabled/;
            sudo mv /opt/resolve/libs/libglib-2.0.so* /opt/resolve/libs/disabled/;
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
            fi;
            echo "Job finished. You may use DaVinci Resolve Studio now. It will take some time to load the Fairlight Engine for the first time, but it's not frozen. Be patient!";
            exit 0;;
          No ) exit 0;;
        esac;
      done;;
    pt-BR )
      echo "Este é o script *resolve-fix* por Psygreg.";
      echo "Ele irá baixar e instalar o DaVinci Resolve Studio e suas dependências a partir do AUR e aplicar uma correção para um erro comum 'undefined symbol'.";
      echo "Prosseguir?";
      select sn in "Sim" "Não"; do
        case $sn in
          Sim )
            yay -S --needed --noconfirm davinci-resolve-studio;
            sudo mkdir /opt/resolve/libs/disabled;
            sudo mv /opt/resolve/libs/libgmodule-2.0.so* /opt/resolve/libs/disabled/;
            sudo mv /opt/resolve/libs/libgio-2.0.so* /opt/resolve/libs/disabled/;
            sudo mv /opt/resolve/libs/libglib-2.0.so* /opt/resolve/libs/disabled/;
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
            fi;
            echo "Concluído. Você pode utilizar o seu software agora. Ele levará algum tempo para iniciar o Fairlight Engine pela primeira vez, mas não estará travado, então seja paciente!";
            exit 0;;
          Não ) exit 0;;
        esac;
      done;;
  esac
done

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
            yay -S --noconfirm davinci-resolve-studio;
            sudo mkdir /opt/resolve/libs/disabled;
            sudo mv /opt/resolve/libs/libgmodule-2.0.so* /opt/resolve/libs/disabled/;
            sudo mv /opt/resolve/libs/libgio-2.0.so* /opt/resolve/libs/disabled/;
            sudo mv /opt/resolve/libs/libglib-2.0.so* /opt/resolve/libs/disabled/;
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
            yay -S --noconfirm davinci-resolve-studio;
            sudo mkdir /opt/resolve/libs/disabled;
            sudo mv /opt/resolve/libs/libgmodule-2.0.so* /opt/resolve/libs/disabled/;
            sudo mv /opt/resolve/libs/libgio-2.0.so* /opt/resolve/libs/disabled/;
            sudo mv /opt/resolve/libs/libglib-2.0.so* /opt/resolve/libs/disabled/;
            echo "Concluído. Você pode utilizar o seu software agora. Ele levará algum tempo para iniciar o Fairlight Engine pela primeira vez, mas não estará travado, então seja paciente!";
            exit 0;;
          Não ) exit 0;;
        esac;
      done;;
    esac
done

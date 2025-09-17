

sudo apt update -y && sudo apt upgrade -y
sudo apt install openjdk-17-jdk -y
java -version  # Should show Java 17

wget -qO- https://raw.githubusercontent.com/Botspot/pi-apps/master/install | bash
# Open Pi-Apps GUI, select "Minecraft Java (Prism Launcher)"
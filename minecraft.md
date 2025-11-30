# Setup Minecraft in Raspberry Pi 5

## initial setup
```
sudo apt update -y && sudo apt upgrade -y
sudo apt install openjdk-17-jdk -y
java -version  # Should show Java 17
```

```
wget -qO- https://raw.githubusercontent.com/Botspot/pi-apps/master/install | bash
```

### Open Pi-Apps GUI, select "Minecraft Java (Prism Launcher)"
- register XBox login which has "Minecraft Java" purchased

### As of 2025Q3
stable combination running smoothly
- Minecraft 1.20.1
- Forge 47.2.0
- CC: Tweaked 1.112.8



### Step-by-Step Fix

#### 1. Recreate the Instance
This error often requires a fresh instance to ensure all files are properly set up.
- Open **Prism Launcher**.
- Delete the problematic instance:
  - Right-click your “CC Tweaked 1.20.1” instance > **Delete**.
  - Confirm deletion (back up any worlds in `~/.local/share/PrismLauncher/instances/<instance_name>/.minecraft/saves` if needed).
- Create a new instance:
  - Click **Add Instance**.
  - Name it (e.g., “CC Tweaked 1.20.1”).
  - Select **Minecraft 1.20.1** from the version dropdown.
  - Click **OK**.
- Verify Minecraft files:
  - Right-click the new instance > **Edit Instance** > **Version** tab.
  - Ensure “Minecraft 1.20.1” is listed with a green checkmark.
  - If it’s missing or has a red X, click **Add to Minecraft.jar** > Select **Minecraft** > Choose **1.20.1** > **Download**.
- Test vanilla Minecraft:
  - Click **Play** to launch 1.20.1 without mods. If it fails, check your internet or Java setup (see Step 3).

#### 2. Install Forge 47.2.0
- In Prism Launcher, right-click the instance > **Edit Instance** > **Version** tab.
- Click **Add to Minecraft.jar** > Select **Forge** > Choose **47.2.0** for Minecraft 1.20.1.
- Click **Install** and wait for the download. If the error reappears:
  - **Manual Forge Install**:
    - Download the Forge 47.2.0 installer from [files.minecraftforge.net/net/minecraftforge/forge/index_1.20.1.html](https://files.minecraftforge.net/net/minecraftforge/forge/index_1.20.1.html) (e.g., `forge-1.20.1-47.2.0-installer.jar`).
    - Run it:
      ```bash
      java -jar ~/Downloads/forge-1.20.1-47.2.0-installer.jar
      ```
    - Select **Install Client** and point to the instance folder (e.g., `~/.local/share/PrismLauncher/instances/CC Tweaked 1.20.1/.minecraft`).
    - In Prism Launcher, refresh the instance (right-click > **Refresh**).
- Verify Forge appears in the **Version** tab (e.g., “Forge 47.2.0”).

#### 3. Verify Java Setup
The error can stem from Java misconfiguration, especially on Raspberry Pi.
- Check Java version:
  ```bash
  java -version
  ```
  Should show `openjdk 17.x` (e.g., 17.0.8). If not, install:
  ```bash
  sudo apt update
  sudo apt install openjdk-17-jre
  ```
- In Prism Launcher, go to **Edit Instance** > **Settings** > **Java**:
  - Set Java path to `/usr/lib/jvm/java-17-openjdk-arm64/bin/java` (or `-armhf` for 32-bit OS).
  - Set memory to 2048MB max (2GB) for Pi 4, or 3072MB (3GB) for Pi 5 to avoid crashes.
- If Java issues persist, reinstall Prism Launcher:
  ```bash
  flatpak update org.prismlauncher.PrismLauncher  # If using Flatpak
  ```
  Or download the latest `.AppImage` from [prismlauncher.org](https://prismlauncher.org/).

#### 4. Add CC: Tweaked
- Download **CC: Tweaked 1.112.8** for Minecraft 1.20.1 from [curseforge.com/minecraft/mc-mods/cc-tweaked](https://www.curseforge.com/minecraft/mc-mods/cc-tweaked) (filter for 1.20.1, Forge).
- In Prism Launcher, right-click instance > **Edit Instance** > **Mods** tab.
- Click **Add File**, select `CCTweaked-1.112.8.jar` from Downloads.
- Launch the instance and test:
  - Create a new world.
  - Craft a Computer (4x Redstone + 1x Iron Block + 4x Stone).
  - Right-click, type `lua`, then `print("Hello, World!")`, and press Ctrl+R.

#### 5. Optimize for Raspberry Pi
- In **Edit Instance** > **Settings**:
  - Render distance: 6-8 chunks.
  - Graphics: Fast, particles Minimal, VSync off.
- Add **OptiFine 1.20.1-HD-U-I6** (from [optifine.net](https://optifine.net/downloads)) to the Mods tab for better FPS.
- Monitor Pi temperature:
  ```bash
  vcgencmd measure_temp
  ```
  If above 70°C, add a fan or heatsinks.

#### 6. Check Logs for Details
If the error persists:
- Right-click instance > **View Logs** after a failed launch.
- Look for lines mentioning `IllegalStateException` or missing files.
- Share the full error stack or key lines for precise debugging.


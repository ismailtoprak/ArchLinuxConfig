# 🐧 Arch Linux Kişisel Kurulum ve Yapılandırma Rehberi

Bu belge, kişisel ihtiyaçlara göre hazırlanmış bir Arch Linux kurulum ve yapılandırma rehberidir. Adımlar test edilmiştir ve sistemde uygulandığı şekliyle belgelenmiştir.

---

## 📦 Kurulum Öncesi

### ⌨️ Klavye Ayarı

```bash
loadkeys trq
```

### 🌐 Ağ Bağlantısı (iwctl ile Wi-Fi)

Live ISO ortamında Wi-Fi bağlantısı kurmak için:

```bash
iwctl
```

Sonrasında sırasıyla:

```bash
device list
station <arayüz_adı> scan
station <arayüz_adı> get-networks
station <arayüz_adı> connect <SSID>
```

Bağlantıyı test etmek için:

```bash
ping archlinux.org
```

---

## 🧰 archinstall Scripti ile Kurulum

Kurulumu başlatmak için:

```bash
archinstall
```

Script içerisinde aşağıdaki seçenekler yapılandırıldı:

- 💽 Dosya Sistemi: `btrfs`
- 🔐 Bootloader: `grub`
- 🖥️ Masaüstü Ortamı: `KDE Plasma`
- 📚 Ek Paketler: `git`, `vim`
- 👤 Kullanıcı Hesabı: oluşturuldu
- 🌐 Ağ, saat, bölge, dil ayarları: yapılandırıldı

Kurulumdan sonra konfigürasyon dosyası:

```
/var/lib/archinstall/installation.json
```

---

## 💾 NTFS Disklerini Otomatik Bağlamak (fstab ile)

### 1. UUID Öğrenme

```bash
sudo blkid
```

Örnek çıktı:
```
/dev/sda1: UUID="1234-ABCD" TYPE="ntfs"
```

### 2. Bağlantı Noktası Oluşturma

```bash
sudo mkdir -p /mnt/The_Doctor
```

### 3. fstab’a Ekleme

```bash
sudo nano /etc/fstab
```

Şu satırı ekleyin:

```fstab
UUID=1234-ABCD  /mnt/The_Doctor  ntfs-3g  defaults,noatime  0  0
```

### 4. Test Etme

```bash
sudo mount -a
```

---

## 🪟 Windows Fast Startup Kapatma (NTFS için)

### Kalıcı Kapatmak için:

1. Denetim Masası → Donanım ve Ses → Güç Seçenekleri  
2. “Güç düğmelerinin yapacaklarını seç”  
3. “Şu anda kullanılamayan ayarları değiştir”  
4. “Hızlı başlatmayı aç” seçeneğinin işaretini kaldır  
5. Kaydet ve çık

### Geçici Olarak Tam Kapatmak için:

- Shift + Kapat (Windows oturumundayken)

---

## 🎨 Tema ve Arayüz

- Tema: **Breeze**
- Simge Seti: **Papirus (Normal)**

---

## 📦 Kurulu Ek Paketler

- `timeshift`
- `spectacle`
- `partitionmanager`
- `ntfs-3g`
- `flatpak`
- `yay`
- `mkinitcpio-firmware`
- `visual-studio-code-bin`
- `google-chrome-bin`
- `docker`, `docker-compose`
- `nvidia-cuda-toolkit` (Docker için)
- `zsh`, `oh-my-zsh`, `powerlevel10k`
- `vim`
- `nomacs`

### Flatpak ile Kurulanlar:

- Mission Center `io.missioncenter.MissionCenter`
- VLC `org.videolan.VLC`
- Qalculate! `io.github.Qalculate.qalculate-qt`
- BleachBit `org.bleachbit.BleachBit`

---

## 🚀 Sistem Optimizasyonu

### Açılış Analizi

```bash
systemd-analyze
systemd-analyze blame
```

### Gereksiz Servisleri Devre Dışı Bırakmak

```bash
sudo systemctl disable docker.service
sudo systemctl disable docker.socket
sudo systemctl stop docker.socket docker.service
sudo systemctl disable containerd
sudo systemctl stop containerd

sudo systemctl disable libvirtd.service
sudo systemctl disable virtlogd.service

sudo systemctl disable NetworkManager-wait-online.service
sudo systemctl mask NetworkManager-wait-online.service

sudo systemctl disable upower.service
sudo systemctl stop upower.service
```

### Preload Kurulumu

```bash
yay -S preload
```

### Mikro Kod ve GRUB Güncellemesi

```bash
sudo pacman -S amd-ucode
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### GRUB Timeout Ayarı

```bash
sudo vim /etc/default/grub
# timeout değerini güncelle
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

---

## 🎮 NVIDIA + KDE Plasma Wayland Optimizasyonu (Arch Linux)

Bu belge, Arch Linux üzerinde NVIDIA ekran kartı ile KDE Plasma (Wayland oturumu) ortamında tam performanslı ve uyumlu bir yapılandırma sağlamak için hazırlanmıştır.

---

### ✅ Gerekli NVIDIA Paketlerini Kur

```bash
sudo pacman -S nvidia-dkms nvidia-utils libva-nvidia-driver libvdpau libxnvctrl
```

#### Açıklamalar:
- `nvidia-dkms`: Kernel güncellemeleriyle otomatik uyumlu NVIDIA sürücüsü
- `nvidia-utils`: OpenGL, CUDA ve diğer kullanıcı araçları
- `libva-nvidia-driver`: VA-API üzerinden donanım hızlandırma
- `libvdpau`: Video decode API desteği
- `libxnvctrl`: nvidia-settings aracı için gereklidir

---

### 🔧 DRM KMS (Kernel Mode Setting) Aktif Et

```bash
echo "options nvidia-drm modeset=1" | sudo tee /etc/modprobe.d/nvidia.conf
```

> Wayland'ın NVIDIA ile çalışması için framebuffer desteği şarttır.

---

### ⚙️ GRUB'a Parametre Ekle

```bash
sudo nano /etc/default/grub
```

`GRUB_CMDLINE_LINUX_DEFAULT` satırına:

```
nvidia_drm.modeset=1
```

Ekledikten sonra:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

---

### 📦 Initramfs Güncelle (mkinitcpio)

```bash
sudo nano /etc/mkinitcpio.conf
```

`MODULES=()` satırına:

```
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
```

Kaydedip çık, ardından:

```bash
sudo mkinitcpio -P
```

---

### 🗑️ X11 NVIDIA Config Dosyasını Temizle

```bash
sudo rm -f /etc/X11/xorg.conf.d/20-nvidia.conf
```

---

### 🖥️ Plasma Wayland Oturumunu Kur ve Başlat

```bash
sudo pacman -S plasma-wayland-session
```

SDDM veya giriş yöneticisinde "Plasma (Wayland)" seç.

---

### 🔋 NVIDIA Performans/Güç Ayarları

```bash
sudo systemctl enable nvidia-persistenced.service
```

---

### 🔎 Donanım Hızlandırma Kontrol

```bash
nvidia-smi
```

---

### 🌐 Firefox & Electron için VA-API Hızlandırma

#### Firefox:
`about:config` sayfasında şunları değiştirin:

- `media.ffmpeg.vaapi.enabled = true`
- `gfx.webrender.all = true`
- `layers.acceleration.force-enabled = true`

---

## 🔍 Kontrol Komutları

```bash
echo $XDG_SESSION_TYPE        # "wayland" olmalı
cat /sys/module/nvidia_drm/parameters/modeset  # 1 olmalı
lsmod | grep nvidia           # yüklü mü kontrol
```

---

### 🧰 Ekstra Tavsiye Paketler

```bash
sudo pacman -S nvtop vulkan-tools egl-wayland nvidia-prime
```

- `nvtop`: NVIDIA canlı GPU kullanımı
- `vulkan-tools`: Vulkan desteği testi için
- `egl-wayland`: EGL Wayland backend (GBM)
- `nvidia-prime`: PRIME offload sistemleri için

---

### 🧠 Sorun Giderme

| Sorun                         | Çözüm                                       |
|------------------------------|----------------------------------------------|
| Wayland başlamıyor           | `nvidia_drm.modeset=1` eksik olabilir       |
| Ekran yırtılması (tearing)   | DRM KMS aktif değilse olur                  |
| KDE donuyor                  | Geçici olarak X11 oturumu kullan            |
| X11 config dosyası kalmış    | `/etc/X11/` altını temizle                  |

---

> 📝 Not: Bu rehber kişisel kullanım içindir, sisteminize özgü farklılıklar olabilir.

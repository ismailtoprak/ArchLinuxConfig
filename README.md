# Arch Linux Kişisel Kurulum ve Yapılandırma Rehberi

Bu belge, kişisel ihtiyaçlara göre hazırlanmış bir Arch Linux kurulum ve yapılandırma rehberidir. Adımlar test edilmiştir ve sistemde uygulandığı şekliyle belgelenmiştir.

---

## 1. Kurulum Öncesi

### 1.1 Klavye Ayarı

```bash
loadkeys trq
```

### 1.2 Ağ Bağlantısı (iwctl ile Wi-Fi)

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

## 2. archinstall Scripti ile Kurulum

Kurulumu başlatmak için:

```bash
archinstall
```

Script içerisinde aşağıdaki seçenekler yapılandırıldı:

- Dosya Sistemi: `ext4`
- Bootloader: `grub`
- Masaüstü Ortamı: `None`
- Kullanıcı Hesabı: oluşturuldu, sudo yetkisi verildi
- Ağ, saat, bölge, dil ayarları: yapılandırıldı

Kurulumdan sonra konfigürasyon dosyası:

```
/var/lib/archinstall/installation.json
```

---

## 3. Kurulum Sonrası Temel Adımlar

### 3.1 Sistemi Güncelle

```bash
sudo pacman -Syu
```

### 3.2 AUR Yardımcısı (yay) Kurulumu

AUR paketlerini kurmak için yay yükleyin:

```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

### 3.3 Flatpak Kurulumu

Flatpak uygulamaları için:

```bash
sudo pacman -S flatpak
```

---

## 4. Toplu Paket Kurulumu ve Liste Güncelleme

Yeni sistemde, eski sistemdeki paketlerin tamamını otomatik olarak kurmak için aşağıdaki adımları izleyin:

- `util/app-installer.sh`: `app-list.txt` dosyasındaki paketleri yeni sisteme otomatik olarak kurar.

### 4.1 Toplu Kurulum

Başka bir sisteme aynı paketleri kurmak için:

```bash
cd util
bash app-installer.sh
```

Not: `app-list.txt` dosyasının eski sistemde güncellenmiş olması gerekir.

### 4.2 Paket Listesini Güncelleme

Kurulumdan sonra yeni paketler eklediyseniz veya mevcut paketlerde değişiklik yaptıysanız, güncel listeyi almak için:

- `util/app-list.sh`: Mevcut sistemde kurulu paketleri `app-list.txt` dosyasına kaydeder.

```bash
cd util
bash app-list.sh
```

Not: Scriptin çalışabilmesi için `yay` ve `flatpak` kurulu olmalıdır.

Bu işlem sonunda `app-list.txt` dosyası aşağıdaki formatta oluşur:

```
pacman:<paket_adı>
aur:<paket_adı>
flatpak:<paket_adı>
```

---

## 5. Tema ve Arayüz (Opsiyonel)

- Global Theme: Layan (Normal)
- Colors: Breeze Light (Normal)
- Application Style: Breeze (Normal)
- Plasma Style: Layan (Normal)
- Window Decorations: Oxygen (Normal)
- Icons: Papirus (Normal)
- Cursors: Volantes Cursors (Normal)
- System Sounds: Ocean
- Splash Screen: Layan (Normal)
- Login Screen: Layan (Normal)

---

## 6. NTFS Disklerini Otomatik Bağlamak (fstab ile)

### 6.1 UUID Öğrenme

```bash
sudo blkid
```

Örnek çıktı:
```
/dev/sda1: UUID="1234-ABCD" TYPE="ntfs"
```

### 6.2 Bağlantı Noktası Oluşturma

```bash
sudo mkdir -p /mnt/The_Doctor
```

### 6.3 fstab’a Ekleme

```bash
sudo nano /etc/fstab
```

Şu satırı ekleyin:

```fstab
UUID=1234-ABCD  /mnt/The_Doctor  ntfs-3g  defaults,noatime  0  0
```

### 6.4 Test Etme

```bash
sudo mount -a
```

---

## 7. Sistem Optimizasyonu

### 7.1 Açılış Analizi

```bash
systemd-analyze
systemd-analyze blame
```

### 7.2 Gereksiz Servisleri Devre Dışı Bırakmak

```bash
sudo systemctl disable docker.service
sudo systemctl disable docker.socket
sudo systemctl disable containerd

sudo systemctl disable NetworkManager-wait-online.service
sudo systemctl mask NetworkManager-wait-online.service
```

### 7.3 Mikro Kod ve GRUB Güncellemesi

```bash
sudo pacman -S amd-ucode
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### 7.4 GRUB Timeout Ayarı

```bash
sudo vim /etc/default/grub
# timeout değerini güncelle
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

---

## 8. NVIDIA + KDE Plasma Wayland Optimizasyonu (Arch Linux)

Bu bölüm, Arch Linux üzerinde NVIDIA ekran kartı ile KDE Plasma (Wayland oturumu) ortamında tam performanslı ve uyumlu bir yapılandırma sağlamak için hazırlanmıştır.

### 8.1 DRM KMS (Kernel Mode Setting) Aktif Et

```bash
echo "options nvidia-drm modeset=1" | sudo tee /etc/modprobe.d/nvidia.conf
```

Wayland'ın NVIDIA ile çalışması için framebuffer desteği şarttır.

### 8.2 GRUB'a Parametre Ekle

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

### 8.3 Initramfs Güncelle (mkinitcpio)

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

### 8.4 NVIDIA Performans/Güç Ayarları

```bash
sudo systemctl enable --now nvidia-persistenced
```

### 8.5 Donanım Hızlandırma Kontrol

```bash
nvidia-smi
```

---

## 9. Kontrol Komutları

```bash
echo $XDG_SESSION_TYPE        # "wayland" olmalı
cat /sys/module/nvidia_drm/parameters/modeset  # 1 olmalı
lsmod | grep nvidia           # yüklü mü kontrol
```

---

## 10. Sorun Giderme

| Sorun                         | Çözüm                                       |
|------------------------------|----------------------------------------------|
| Wayland başlamıyor           | `nvidia_drm.modeset=1` eksik olabilir       |
| Ekran yırtılması (tearing)   | DRM KMS aktif değilse olur                  |

---

Not: Bu rehber kişisel kullanım içindir, sisteminize özgü farklılıklar olabilir.

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

> 📝 Not: Bu rehber kişisel kullanım içindir, sisteminize özgü farklılıklar olabilir.

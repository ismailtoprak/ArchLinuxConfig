# 🐧 Arch Linux Kişisel Kurulum ve Yapılandırma Rehberi

Bu rehber, tamamen kişisel ihtiyaçlara yönelik hazırlanmış bir Arch Linux kurulum ve yapılandırma belgesidir. Adımlar tek tek uygulanmış ve not edilmiştir.

---

## 📡 1. Ağ Bağlantısı (iwctl ile Wi-Fi)

Live ISO ortamında Wi-Fi bağlantısı kurmak için:

```bash
iwctl
```

Ardından:

```bash
device list
station <arayüz_adı> scan
station <arayüz_adı> get-networks
station <arayüz_adı> connect <SSID>
```

Bağlantı sağlandıktan sonra `ping archlinux.org` komutuyla test edebilirsin.

---

## ⚙️ 2. archinstall Scripti ile Kurulum

Arch Linux'un resmi kurulum betiğini başlatmak için:

```bash
archinstall
```

Script üzerinden aşağıdaki parametreleri yapılandır:

- Disk bölümlendirme (manuel veya otomatik)
- Dosya sistemi (örnek: btrfs)
- Bootloader (örnek: systemd-boot, grub)
- Masaüstü ortamı (örnek: KDE Plasma)
- Ek yazılımlar
- Kullanıcı hesabı
- Ağ ayarları
- Saat, bölge, dil ayarları

Kurulum tamamlandıktan sonra yapılandırma JSON dosyası şu konumda bulunabilir:

```
/var/lib/archinstall/installation.json
```

---

## 📦 3. NTFS Disklerini fstab ile Otomatik Mount Etmek

### 1. UUID’yi Bulma

```bash
blkid
```

Örnek çıktı:

```
/dev/sda1: UUID="1234-ABCD" TYPE="ntfs"
```

### 2. Mount Noktası Oluşturma

```bash
sudo mkdir -p /mnt/veriler
```

### 3. fstab Dosyasına Ekleme

```bash
sudo nano /etc/fstab
```

Aşağıdaki satırı dosyanın sonuna ekleyin:

```fstab
UUID=1234-ABCD  /mnt/veriler  ntfs3  defaults,noatime  0  0
```

`ntfs3` çalışmazsa, şu satırı kullanın:

```fstab
UUID=1234-ABCD  /mnt/veriler  ntfs-3g  defaults,noatime  0  0
```

### 4. Test Etme

```bash
sudo mount -a
```

---

## 🪫 4. Windows Fast Startup Kapatma (NTFS için Gerekli)

Windows'ta Fast Startup açık olduğunda NTFS disk Linux'ta "dirty" olarak algılanır ve mount edilemez.

### Kalıcı Olarak Kapatma:

1. Denetim Masası → Donanım ve Ses → Güç Seçenekleri
2. “Güç düğmelerinin yapacaklarını seç”e tıkla
3. “Şu anda kullanılamayan ayarları değiştir”e tıkla
4. “Hızlı başlatmayı aç” kutusunun işaretini kaldır
5. Değişiklikleri kaydet

### Geçici Olarak Tam Kapatma:

- Shift tuşuna basılı tutarak **Kapat** butonuna tıkla.

---

## 🧠 5. VS Code Ayar Senkronizasyonu (Flatpak/AUR)

### Sorun:
VS Code ile Microsoft hesabına giriş yapılmasına rağmen ayarların senkronize olmaması.

### Olası Sebepler ve Çözümler:

- `vscodium` ya da `code-oss` gibi sürümler Microsoft senkronizasyonunu desteklemez.
- Doğru paket: `visual-studio-code-bin` (AUR üzerinden kurulabilir).
- Giriş yaptıktan sonra `F1 > Settings Sync: Turn On` komutu çalıştırılmalı.
- Eklentiler bulutta görünüyorsa manuel olarak `Extensions` sekmesinden indirilebilir.

Kurulu sürümü kontrol etmek için:

```bash
pacman -Qi visual-studio-code-bin
```

---

Tema -> Breeze
Icons -> Papirus Normal

Kurulan Ek paketler:

timeshift
spectacle
kde partition manager
ntfs-3g
flatpak
yay
vs-code-bin
google-chrome-bin
docker & docker-compose
nvidia-cuda-toolkit : docker için
zsh : oh-my-zsh : powerlevel10k
vim
nomacs

discover : mission center : appstream:io.missioncenter.MissionCenter
discover : vlc
discover : Qalculate! : appstream:io.github.Qalculate.qalculate-qt
discover : BleachBit : appstream:org.bleachbit.BleachBit

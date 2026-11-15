# NovaStore – E-Ticaret Veritabanı Projesi

[English version](README.md)

NovaStore adlı kurgusal bir online mağaza için SQL Server'a yönelik T-SQL ile yazılmış ilişkisel bir veritabanı. Proje; veritabanı tasarımını, örnek verileri, analiz sorgularını, bir görünümü (view) ve yedeklemeyi kapsar. Bir SQL eğitiminin bitirme projesidir.

## İçindekiler

| Dosya                                 | Açıklama                                                                  |
| ------------------------------------- | ------------------------------------------------------------------------- |
| `ElifHazalBuber_NovaStore_Proje.sql`  | Tüm betik: tablolar, örnek veriler, sorgular, view ve yedekleme           |
| `ElifHazalBuber_NovaStore_Proje.docx` | Kod, sonuç ekran görüntüleri ve açıklamaları içeren proje raporu (Türkçe) |
| `ElifHazalBuber_NovaStore_Proje.png`  | Tabloların ilişkisel diyagramı                                            |

## Veritabanı Tasarımı

Veritabanının adı `NovaStoreDB` ve beş tablosu vardır:

- **Categories**: ürün kategorileri
- **Products**: fiyat ve stok bilgisi olan, bir kategoriye bağlı ürünler
- **Customers**: benzersiz e-posta adresi olan müşteriler
- **Orders**: bir müşteriye bağlı siparişler
- **OrderDetails**: siparişleri ve ürünleri birbirine bağlayan ara tablo

![İlişkisel diyagram](ElifHazalBuber_NovaStore_Proje.png)

## Betik İçeriği

1. **Veritabanı tasarımı (DDL):** `NovaStoreDB` veritabanını ve beş tabloyu oluşturur; birincil anahtarlar, yabancı anahtarlar, benzersiz e-posta, varsayılan stok değeri ve varsayılan sipariş tarihi içerir.
2. **Örnek veriler (DML):** 5 kategori, 13 ürün, 6 müşteri, 10 sipariş ve 16 sipariş detay satırı.
3. **Sorgular (DQL):**
   - Stoğu 20'nin altında olan ürünler, stoğa göre azalan sıralı
   - Müşteriler ve sipariş tarihleri (`INNER JOIN`)
   - Belirli bir müşterinin satın aldığı ürünler (beş tablolu `JOIN`)
   - Kategori başına ürün sayısı (`LEFT JOIN`, `GROUP BY`, `COUNT`)
   - Müşteri başına toplam ciro (`SUM`, `GROUP BY`)
   - Her siparişin üzerinden geçen gün sayısı (`DATEDIFF`, `GETDATE`)
4. **İleri düzey nesneler:** `vw_SiparisOzet` görünümü ve tam veritabanı yedeği (`BACKUP DATABASE`).

## Nasıl Çalıştırılır

Betik, Docker içindeki bir SQL Server üzerinde çalıştırılmış ve Visual Studio Code'da SQL Server (mssql) eklentisiyle kullanılmıştır.

1. SQL Server'ı Docker'da başlatın (parolayı kendi parolanızla değiştirin):
   ```bash
   docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=YourStrong!Passw0rd" \
     -p 1433:1433 --name sqlserver -d mcr.microsoft.com/mssql/server:2022-latest
   ```
2. VS Code'da `localhost,1433` adresine `sa` kullanıcısı ve parolanızla bağlanın.
3. `ElifHazalBuber_NovaStore_Proje.sql` dosyasını açıp çalıştırın (dosyanın tamamını ya da seçerek her sorguyu tek tek).

Notlar:

- Betik `DROP DATABASE IF EXISTS NovaStoreDB` ile başlar; bu yüzden tekrar çalıştırmak veritabanını baştan oluşturur.
- Ödev, yedeğin `C:\Yedek\` klasörüne alınmasını ister; bu bir Windows yoludur. Betikte bu sürüm ve `/var/opt/mssql/data/` klasörüne yazan bir Linux/Docker sürümü bulunur. Docker içinde yalnızca Linux sürümü çalışır.
- "Üzerinden geçen gün" sorgusunun sonucu, çalıştırıldığı güne göre değişir.

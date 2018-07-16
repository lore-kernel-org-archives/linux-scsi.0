From: Martijn Coenen <maco@android.com>
Subject: [PATCH 6/6] RFC: USB: storage: move symbols into USB_STORAGE namespace.
Date: Mon, 16 Jul 2018 14:21:25 +0200
Message-ID: <20180716122125.175792-7-maco@android.com>
References: <20180716122125.175792-1-maco@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180716122125.175792-1-maco@android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Martijn Coenen <maco@android.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Geert Uytterhoeven <geert@linux-m68k.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Oliver Neukum <oneukum@suse.com>, Arnd Bergmann <arnd@arndb.de>, Jessica Yu <jeyu@kernel.org>, Stephen Boyd <sboyd@codeaurora.org>, Philippe Ombredanne <pombredanne@nexb.com>, Kate Stewart <kstewart@linuxfoundation.org>, Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-scsi
List-Id: linux-scsi@vger.kernel.org

Modules using these symbols must now import this namesapce explicitly.

Signed-off-by: Martijn Coenen <maco@android.com>
---
 drivers/usb/storage/alauda.c        |  1 +
 drivers/usb/storage/cypress_atacb.c |  1 +
 drivers/usb/storage/datafab.c       |  1 +
 drivers/usb/storage/ene_ub6250.c    |  1 +
 drivers/usb/storage/freecom.c       |  1 +
 drivers/usb/storage/isd200.c        |  1 +
 drivers/usb/storage/jumpshot.c      |  1 +
 drivers/usb/storage/karma.c         |  1 +
 drivers/usb/storage/onetouch.c      |  1 +
 drivers/usb/storage/realtek_cr.c    |  1 +
 drivers/usb/storage/sddr09.c        |  1 +
 drivers/usb/storage/sddr55.c        |  1 +
 drivers/usb/storage/shuttle_usbat.c |  1 +
 drivers/usb/storage/uas.c           |  1 +
 drivers/usb/storage/usb.c           | 20 ++++++++++----------
 15 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/storage/alauda.c b/drivers/usb/storage/alauda.c
index 6b8edf6178df..ddab2cd3d2e7 100644
--- a/drivers/usb/storage/alauda.c
+++ b/drivers/usb/storage/alauda.c
@@ -36,6 +36,7 @@
 MODULE_DESCRIPTION("Driver for Alauda-based card readers");
 MODULE_AUTHOR("Daniel Drake <dsd@gentoo.org>");
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(USB_STORAGE);
 
 /*
  * Status bytes
diff --git a/drivers/usb/storage/cypress_atacb.c b/drivers/usb/storage/cypress_atacb.c
index 4825902377eb..a6f3267bbef6 100644
--- a/drivers/usb/storage/cypress_atacb.c
+++ b/drivers/usb/storage/cypress_atacb.c
@@ -22,6 +22,7 @@
 MODULE_DESCRIPTION("SAT support for Cypress USB/ATA bridges with ATACB");
 MODULE_AUTHOR("Matthieu Castet <castet.matthieu@free.fr>");
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(USB_STORAGE);
 
 /*
  * The table of devices
diff --git a/drivers/usb/storage/datafab.c b/drivers/usb/storage/datafab.c
index 09353be199be..588818483f4b 100644
--- a/drivers/usb/storage/datafab.c
+++ b/drivers/usb/storage/datafab.c
@@ -54,6 +54,7 @@
 MODULE_DESCRIPTION("Driver for Datafab USB Compact Flash reader");
 MODULE_AUTHOR("Jimmie Mayfield <mayfield+datafab@sackheads.org>");
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(USB_STORAGE);
 
 struct datafab_info {
 	unsigned long   sectors;	/* total sector count */
diff --git a/drivers/usb/storage/ene_ub6250.c b/drivers/usb/storage/ene_ub6250.c
index 4d261e4de9ad..57e782a62acd 100644
--- a/drivers/usb/storage/ene_ub6250.c
+++ b/drivers/usb/storage/ene_ub6250.c
@@ -26,6 +26,7 @@
 
 MODULE_DESCRIPTION("Driver for ENE UB6250 reader");
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(USB_STORAGE);
 MODULE_FIRMWARE(SD_INIT1_FIRMWARE);
 MODULE_FIRMWARE(SD_INIT2_FIRMWARE);
 MODULE_FIRMWARE(SD_RW_FIRMWARE);
diff --git a/drivers/usb/storage/freecom.c b/drivers/usb/storage/freecom.c
index 4f542df37a44..34e7eaff1174 100644
--- a/drivers/usb/storage/freecom.c
+++ b/drivers/usb/storage/freecom.c
@@ -29,6 +29,7 @@
 MODULE_DESCRIPTION("Driver for Freecom USB/IDE adaptor");
 MODULE_AUTHOR("David Brown <usb-storage@davidb.org>");
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(USB_STORAGE);
 
 #ifdef CONFIG_USB_STORAGE_DEBUG
 static void pdump(struct us_data *us, void *ibuffer, int length);
diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index f5e4500d9970..7abb5687b2f6 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -53,6 +53,7 @@
 MODULE_DESCRIPTION("Driver for In-System Design, Inc. ISD200 ASIC");
 MODULE_AUTHOR("Björn Stenberg <bjorn@haxx.se>");
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(USB_STORAGE);
 
 static int isd200_Initialization(struct us_data *us);
 
diff --git a/drivers/usb/storage/jumpshot.c b/drivers/usb/storage/jumpshot.c
index 917f170c4124..229bf0c1afc9 100644
--- a/drivers/usb/storage/jumpshot.c
+++ b/drivers/usb/storage/jumpshot.c
@@ -51,6 +51,7 @@
 MODULE_DESCRIPTION("Driver for Lexar \"Jumpshot\" Compact Flash reader");
 MODULE_AUTHOR("Jimmie Mayfield <mayfield+usb@sackheads.org>");
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(USB_STORAGE);
 
 /*
  * The table of devices
diff --git a/drivers/usb/storage/karma.c b/drivers/usb/storage/karma.c
index edcf2be0e0eb..2b6e74afdcbd 100644
--- a/drivers/usb/storage/karma.c
+++ b/drivers/usb/storage/karma.c
@@ -23,6 +23,7 @@
 MODULE_DESCRIPTION("Driver for Rio Karma");
 MODULE_AUTHOR("Bob Copeland <me@bobcopeland.com>, Keith Bennett <keith@mcs.st-and.ac.uk>");
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(USB_STORAGE);
 
 #define RIO_PREFIX "RIOP\x00"
 #define RIO_PREFIX_LEN 5
diff --git a/drivers/usb/storage/onetouch.c b/drivers/usb/storage/onetouch.c
index 39a5009a41a6..a989fe930e21 100644
--- a/drivers/usb/storage/onetouch.c
+++ b/drivers/usb/storage/onetouch.c
@@ -25,6 +25,7 @@
 MODULE_DESCRIPTION("Maxtor USB OneTouch hard drive button driver");
 MODULE_AUTHOR("Nick Sillik <n.sillik@temple.edu>");
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(USB_STORAGE);
 
 #define ONETOUCH_PKT_LEN        0x02
 #define ONETOUCH_BUTTON         KEY_PROG1
diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
index 31b024441938..96c45fee687a 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -35,6 +35,7 @@
 MODULE_DESCRIPTION("Driver for Realtek USB Card Reader");
 MODULE_AUTHOR("wwang <wei_wang@realsil.com.cn>");
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(USB_STORAGE);
 
 static int auto_delink_en = 1;
 module_param(auto_delink_en, int, S_IRUGO | S_IWUSR);
diff --git a/drivers/usb/storage/sddr09.c b/drivers/usb/storage/sddr09.c
index bc9da736bdfc..51bcd4a43690 100644
--- a/drivers/usb/storage/sddr09.c
+++ b/drivers/usb/storage/sddr09.c
@@ -47,6 +47,7 @@
 MODULE_DESCRIPTION("Driver for SanDisk SDDR-09 SmartMedia reader");
 MODULE_AUTHOR("Andries Brouwer <aeb@cwi.nl>, Robert Baruch <autophile@starband.net>");
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(USB_STORAGE);
 
 static int usb_stor_sddr09_dpcm_init(struct us_data *us);
 static int sddr09_transport(struct scsi_cmnd *srb, struct us_data *us);
diff --git a/drivers/usb/storage/sddr55.c b/drivers/usb/storage/sddr55.c
index b8527c55335b..ba955d65eb0e 100644
--- a/drivers/usb/storage/sddr55.c
+++ b/drivers/usb/storage/sddr55.c
@@ -29,6 +29,7 @@
 MODULE_DESCRIPTION("Driver for SanDisk SDDR-55 SmartMedia reader");
 MODULE_AUTHOR("Simon Munton");
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(USB_STORAGE);
 
 /*
  * The table of devices
diff --git a/drivers/usb/storage/shuttle_usbat.c b/drivers/usb/storage/shuttle_usbat.c
index 854498e1012c..54aa1392c9ca 100644
--- a/drivers/usb/storage/shuttle_usbat.c
+++ b/drivers/usb/storage/shuttle_usbat.c
@@ -48,6 +48,7 @@
 MODULE_DESCRIPTION("Driver for SCM Microsystems (a.k.a. Shuttle) USB-ATAPI cable");
 MODULE_AUTHOR("Daniel Drake <dsd@gentoo.org>, Robert Baruch <autophile@starband.net>");
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(USB_STORAGE);
 
 /* Supported device types */
 #define USBAT_DEV_HP8200	0x01
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 9e9de5452860..0a9b20478ee9 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -1195,5 +1195,6 @@ static struct usb_driver uas_driver = {
 module_usb_driver(uas_driver);
 
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(USB_STORAGE);
 MODULE_AUTHOR(
 	"Hans de Goede <hdegoede@redhat.com>, Matthew Wilcox and Sarah Sharp");
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 9a79cd9762f3..fd5adc4e95d8 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -184,7 +184,7 @@ int usb_stor_suspend(struct usb_interface *iface, pm_message_t message)
 	mutex_unlock(&us->dev_mutex);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(usb_stor_suspend);
+EXPORT_SYMBOL_NS_GPL(usb_stor_suspend, USB_STORAGE);
 
 int usb_stor_resume(struct usb_interface *iface)
 {
@@ -198,7 +198,7 @@ int usb_stor_resume(struct usb_interface *iface)
 	mutex_unlock(&us->dev_mutex);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(usb_stor_resume);
+EXPORT_SYMBOL_NS_GPL(usb_stor_resume, USB_STORAGE);
 
 int usb_stor_reset_resume(struct usb_interface *iface)
 {
@@ -213,7 +213,7 @@ int usb_stor_reset_resume(struct usb_interface *iface)
 	 */
 	return 0;
 }
-EXPORT_SYMBOL_GPL(usb_stor_reset_resume);
+EXPORT_SYMBOL_NS_GPL(usb_stor_reset_resume, USB_STORAGE);
 
 #endif /* CONFIG_PM */
 
@@ -230,7 +230,7 @@ int usb_stor_pre_reset(struct usb_interface *iface)
 	mutex_lock(&us->dev_mutex);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(usb_stor_pre_reset);
+EXPORT_SYMBOL_NS_GPL(usb_stor_pre_reset, USB_STORAGE);
 
 int usb_stor_post_reset(struct usb_interface *iface)
 {
@@ -247,7 +247,7 @@ int usb_stor_post_reset(struct usb_interface *iface)
 	mutex_unlock(&us->dev_mutex);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(usb_stor_post_reset);
+EXPORT_SYMBOL_NS_GPL(usb_stor_post_reset, USB_STORAGE);
 
 /*
  * fill_inquiry_response takes an unsigned char array (which must
@@ -293,7 +293,7 @@ void fill_inquiry_response(struct us_data *us, unsigned char *data,
 
 	usb_stor_set_xfer_buf(data, data_len, us->srb);
 }
-EXPORT_SYMBOL_GPL(fill_inquiry_response);
+EXPORT_SYMBOL_NS_GPL(fill_inquiry_response, USB_STORAGE);
 
 static int usb_stor_control_thread(void * __us)
 {
@@ -579,7 +579,7 @@ void usb_stor_adjust_quirks(struct usb_device *udev, unsigned long *fflags)
 	}
 	*fflags = (*fflags & ~mask) | f;
 }
-EXPORT_SYMBOL_GPL(usb_stor_adjust_quirks);
+EXPORT_SYMBOL_NS_GPL(usb_stor_adjust_quirks, USB_STORAGE);
 
 /* Get the unusual_devs entries and the string descriptors */
 static int get_device_info(struct us_data *us, const struct usb_device_id *id,
@@ -990,7 +990,7 @@ int usb_stor_probe1(struct us_data **pus,
 	release_everything(us);
 	return result;
 }
-EXPORT_SYMBOL_GPL(usb_stor_probe1);
+EXPORT_SYMBOL_NS_GPL(usb_stor_probe1, USB_STORAGE);
 
 /* Second part of general USB mass-storage probing */
 int usb_stor_probe2(struct us_data *us)
@@ -1074,7 +1074,7 @@ int usb_stor_probe2(struct us_data *us)
 	release_everything(us);
 	return result;
 }
-EXPORT_SYMBOL_GPL(usb_stor_probe2);
+EXPORT_SYMBOL_NS_GPL(usb_stor_probe2, USB_STORAGE);
 
 /* Handle a USB mass-storage disconnect */
 void usb_stor_disconnect(struct usb_interface *intf)
@@ -1084,7 +1084,7 @@ void usb_stor_disconnect(struct usb_interface *intf)
 	quiesce_and_remove_host(us);
 	release_everything(us);
 }
-EXPORT_SYMBOL_GPL(usb_stor_disconnect);
+EXPORT_SYMBOL_NS_GPL(usb_stor_disconnect, USB_STORAGE);
 
 static struct scsi_host_template usb_stor_host_template;
 
-- 
2.18.0.203.gfac676dfb9-goog

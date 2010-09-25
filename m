From: "Justin P. Mattock" <justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC 3/3 v3]update broken web addresses archive dot org
Date: Fri, 24 Sep 2010 17:08:57 -0700
Message-ID: <1285373337-10945-3-git-send-email-justinmattock@gmail.com>
References: <1285373337-10945-1-git-send-email-justinmattock@gmail.com>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1285373337-10945-1-git-send-email-justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Justin P. Mattock" <justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Below is just a patch showing all the archive.org in the kernel so far.
up to you if you guys want to use this..

Signed-off-by: Justin P. Mattock <justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

---
 drivers/block/Kconfig                     |    2 +-
 drivers/edac/i82975x_edac.c               |    2 +-
 drivers/hwmon/hwmon-vid.c                 |    6 +++---
 drivers/input/misc/cm109.c                |    4 ++--
 drivers/media/IR/keymaps/rc-rc5-tv.c      |    2 +-
 drivers/media/dvb/pluto2/pluto2.c         |    2 +-
 drivers/media/radio/Kconfig               |    4 ++--
 drivers/media/radio/radio-aztech.c        |    2 +-
 drivers/media/video/bt8xx/bttv-cards.c    |    2 +-
 drivers/media/video/pwc/philips.txt       |    2 +-
 drivers/mtd/maps/Kconfig                  |    6 +++---
 drivers/mtd/maps/pismo.c                  |    2 +-
 drivers/mtd/maps/sc520cdp.c               |    2 +-
 drivers/net/8139too.c                     |    2 +-
 drivers/net/Kconfig                       |   18 +++++++++---------
 drivers/net/acenic.c                      |    2 +-
 drivers/net/fealnx.c                      |    2 +-
 drivers/net/hamachi.c                     |    4 +++-
 drivers/net/lne390.c                      |    4 ++--
 drivers/net/natsemi.c                     |    9 ++++-----
 drivers/net/pci-skeleton.c                |    4 ++--
 drivers/net/starfire.c                    |    7 +++----
 drivers/net/sundance.c                    |    6 +++---
 drivers/net/tokenring/Kconfig             |    2 +-
 drivers/net/wan/Kconfig                   |   12 ++++++------
 drivers/net/wan/cosa.c                    |    3 ++-
 drivers/net/wan/farsync.c                 |    4 ++--
 drivers/net/wan/sbni.c                    |    2 +-
 drivers/net/wireless/ath/ath5k/reg.h      |    2 +-
 drivers/net/wireless/hostap/hostap_cs.c   |    2 +-
 drivers/parport/Kconfig                   |    4 ++--
 drivers/scsi/arm/Kconfig                  |    2 +-
 drivers/scsi/ibmmca.c                     |    4 ++--
 drivers/serial/altera_uart.c              |    2 +-
 drivers/serial/sn_console.c               |    2 +-
 drivers/staging/comedi/drivers/c6xdigio.c |    4 ++--
 drivers/staging/comedi/drivers/pcl711.c   |    2 +-
 drivers/staging/go7007/go7007.txt         |    8 ++++----
 drivers/usb/serial/cypress_m8.c           |    2 +-
 drivers/usb/storage/unusual_devs.h        |    2 +-
 drivers/video/macfb.c                     |    2 +-
 drivers/video/s3fb.c                      |    2 +-
 drivers/video/svgalib.c                   |    2 +-
 drivers/video/vt8623fb.c                  |    2 +-
 drivers/watchdog/pcwd.c                   |    2 +-
 fs/ncpfs/Kconfig                          |    3 ++-
 fs/nls/Kconfig                            |    2 +-
 fs/nls/nls_base.c                         |    2 +-
 fs/reiserfs/procfs.c                      |    4 ++--
 include/linux/edd.h                       |    5 +++--
 include/linux/mtd/pismo.h                 |    2 +-
 include/scsi/sg.h                         |   10 +++++-----
 net/ipv4/Kconfig                          |    4 ++--
 net/ipv4/tcp_illinois.c                   |    2 +-
 net/ipv4/tcp_lp.c                         |    2 +-
 sound/isa/Kconfig                         |    2 +-
 sound/isa/cmi8330.c                       |    2 +-
 sound/oss/Kconfig                         |    4 ++--
 sound/pci/ac97/ac97_patch.c               |    2 +-
 sound/pci/nm256/nm256.c                   |    2 +-
 60 files changed, 108 insertions(+), 105 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index de27768..645a3f8 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -169,7 +169,7 @@ config BLK_DEV_UMEM
 	---help---
 	  Saying Y here will include support for the MM5415 family of
 	  battery backed (Non-volatile) RAM cards.
-	  <http://www.umem.com/>
+	  <http://web.archive.org/web/%2A/http://www.umem.com/>
 
 	  The cards appear as block devices that can be partitioned into
 	  as many as 15 partitions.
diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index 3218819..b2e6c21 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -1,6 +1,6 @@
 /*
  * Intel 82975X Memory Controller kernel module
- * (C) 2007 aCarLab (India) Pvt. Ltd. (http://acarlab.com)
+ * (C) 2007 aCarLab (India) Pvt. Ltd. (http://web.archive.org/web/%2A/http://acarlab.com)
  * (C) 2007 jetzbroadband (http://jetzbroadband.com)
  * This file may be distributed under the terms of the
  * GNU General Public License.
diff --git a/drivers/hwmon/hwmon-vid.c b/drivers/hwmon/hwmon-vid.c
index 897702d..a26fa3f 100644
--- a/drivers/hwmon/hwmon-vid.c
+++ b/drivers/hwmon/hwmon-vid.c
@@ -43,15 +43,15 @@
  * This corresponds to an arbitrary VRM code of 24 in the functions below.
  * These CPU models (K8 revision <= E) have 5 VID pins. See also:
  * Revision Guide for AMD Athlon 64 and AMD Opteron Processors, AMD Publication 25759,
- * http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/25759.pdf
+ * http://web.archive.org/web/%2A/http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/25759.pdf 
  *
  * AMD NPT Family 0Fh Processors, AMD Publication 32559,
- * http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/32559.pdf
+ * http://web.archive.org/web/%2A/http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/32559.pdf
  * Table 71. VID Code Voltages
  * This corresponds to an arbitrary VRM code of 25 in the functions below.
  * These CPU models (K8 revision >= F) have 6 VID pins. See also:
  * Revision Guide for AMD NPT Family 0Fh Processors, AMD Publication 33610,
- * http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/33610.pdf
+ * http://web.archive.org/web/%2A/http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/33610.pdf
  *
  * The 17 specification is in fact Intel Mobile Voltage Positioning -
  * (IMVP-II). You can find more information in the datasheet of Max1718
diff --git a/drivers/input/misc/cm109.c b/drivers/input/misc/cm109.c
index b09c7d1..9007600 100644
--- a/drivers/input/misc/cm109.c
+++ b/drivers/input/misc/cm109.c
@@ -230,7 +230,7 @@ static unsigned short keymap_gtalk(int scancode)
 
 /*
  * Keymap for Allied-Telesis Corega USBPH01
- * http://www.alliedtelesis-corega.com/2/1344/1437/1360/chprd.html
+ * http://web.archive.org/web/%2A/http://www.alliedtelesis-corega.com/2/1344/1437/1360/chprd.html 
  *
  * Contributed by july-Kj59jvlQeyU@public.gmane.org
  */
@@ -260,7 +260,7 @@ static unsigned short keymap_usbph01(int scancode)
 /*
  * Keymap for ATCom AU-100
  * http://www.atcom.cn/products.html 
- * http://www.packetizer.com/products/au100/
+ * http://web.archive.org/web/%2A/http://www.packetizer.com/products/au100/ 
  * http://www.voip-info.org/wiki/view/AU-100
  *
  * Contributed by daniel-R/FLGEdV95bo9U+Z1CfBt0SU0eOFXohjCypLqA8HKkk@public.gmane.org
diff --git a/drivers/media/IR/keymaps/rc-rc5-tv.c b/drivers/media/IR/keymaps/rc-rc5-tv.c
index 73cce2f..61be0bd 100644
--- a/drivers/media/IR/keymaps/rc-rc5-tv.c
+++ b/drivers/media/IR/keymaps/rc-rc5-tv.c
@@ -13,7 +13,7 @@
 #include <media/rc-map.h>
 
 /* generic RC5 keytable                                          */
-/* see http://users.pandora.be/nenya/electronics/rc5/codes00.htm */
+/* see http://web.archive.org/web/%2A/http://users.pandora.be/nenya/electronics/rc5/codes00.htm */
 /* used by old (black) Hauppauge remotes                         */
 
 static struct ir_scancode rc5_tv[] = {
diff --git a/drivers/media/dvb/pluto2/pluto2.c b/drivers/media/dvb/pluto2/pluto2.c
index 1c79821..c709289 100644
--- a/drivers/media/dvb/pluto2/pluto2.c
+++ b/drivers/media/dvb/pluto2/pluto2.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2005 Andreas Oberritter <obi-dJidKbW2IEtAfugRpC6u6w@public.gmane.org>
  *
- * based on pluto2.c 1.10 - http://instinct-wp8.no-ip.org/pluto/
+ * based on pluto2.c 1.10 - http://web.archive.org/web/%2A/http://instinct-wp8.no-ip.org/pluto/ 
  * 	by Dany Salman <salmandany-Qt13gs6zZMY@public.gmane.org>
  *	Copyright (c) 2004 TDF
  *
diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 83567b8..c199ed9 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -24,7 +24,7 @@ config RADIO_CADET
 	  <file:Documentation/video4linux/API.html>.
 
 	  Further documentation on this driver can be found on the WWW at
-	  <http://linux.blackhawke.net/cadet/>.
+	  <http://web.archive.org/web/%2A/http://linux.blackhawke.net/cadet/>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-cadet.
@@ -237,7 +237,7 @@ config RADIO_SF16FMR2
 	  In order to control your radio card, you will need to use programs
 	  that are compatible with the Video For Linux API.  Information on
 	  this API and pointers to "v4l" programs may be found on the WWW at
-	  <http://roadrunner.swansea.uk.linux.org/v4l.shtml>.
+	  <http://web.archive.org/web/%2A/http://roadrunner.swansea.uk.linux.org/v4l.shtml>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-sf16fmr2.
diff --git a/drivers/media/radio/radio-aztech.c b/drivers/media/radio/radio-aztech.c
index c223113..24926026 100644
--- a/drivers/media/radio/radio-aztech.c
+++ b/drivers/media/radio/radio-aztech.c
@@ -10,7 +10,7 @@
  * Scott McGrath    (smcgrath-nSUzK56CgV/0HvdDICh8l/Z8FUJU4vz8@public.gmane.org)
  * William McGrath  (wmcgrath-nSUzK56CgV/0HvdDICh8l/Z8FUJU4vz8@public.gmane.org)
  *
- * The basis for this code may be found at http://bigbang.vtc.vsc.edu/fmradio/
+ * The basis for this code may be found at http://web.archive.org/web/%2A/http://bigbang.vtc.vsc.edu/fmradio/ 
  * along with more information on the card itself.
  *
  * History:
diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/video/bt8xx/bttv-cards.c
index 7af56cd..0c2f677 100644
--- a/drivers/media/video/bt8xx/bttv-cards.c
+++ b/drivers/media/video/bt8xx/bttv-cards.c
@@ -2290,7 +2290,7 @@ struct tvcard bttv_tvcards[] = {
 		.tuner_addr	= ADDR_UNSET,
 	},
 	[BTTV_BOARD_SPIRIT_TV] = {
-		/* Spirit TV Tuner from http://spiritmodems.com.au */
+		/* Spirit TV Tuner from http://web.archive.org/web/%2A/http://spiritmodems.com.au */
 		/* Stafford Goodsell <surge-yZ+Hga93jg6WPPBFgQShfWD2FQJk+8+b@public.gmane.org> */
 		.name           = "Spirit TV Tuner",
 		.video_inputs   = 3,
diff --git a/drivers/media/video/pwc/philips.txt b/drivers/media/video/pwc/philips.txt
index d38dd79..751f114 100644
--- a/drivers/media/video/pwc/philips.txt
+++ b/drivers/media/video/pwc/philips.txt
@@ -1,6 +1,6 @@
 This file contains some additional information for the Philips and OEM webcams.
 E-mail: webcam-uBJCvfnM1px5YqklawuBOA@public.gmane.org                        Last updated: 2004-01-19
-Site: http://www.smcc.demon.nl/webcam/
+Site: http://web.archive.org/web/*/http://www.smcc.demon.nl/webcam/ 
 
 As of this moment, the following cameras are supported:
  * Philips PCA645
diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index 142efd2..1c3f0ca 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -531,9 +531,9 @@ config MTD_PISMO
 	depends on ARCH_VERSATILE
 	help
 	  This driver allows for discovery of PISMO modules - see
-	  <http://www.pismoworld.org/>.  These are small modules containing
-	  up to five memory devices (eg, SRAM, flash, DOC) described by an
-	  I2C EEPROM.
+	  <http://web.archive.org/web/%2A/http://www.pismoworld.org/>. 
+	  These are small modules containing up to five memory devices 
+	  (eg, SRAM, flash, DOC) described by an I2C EEPROM.
 
 	  This driver does not create any MTD maps itself; instead it
 	  creates MTD physmap and MTD SRAM platform devices.  If you
diff --git a/drivers/mtd/maps/pismo.c b/drivers/mtd/maps/pismo.c
index f4ce273..b42eecb 100644
--- a/drivers/mtd/maps/pismo.c
+++ b/drivers/mtd/maps/pismo.c
@@ -1,5 +1,5 @@
 /*
- * PISMO memory driver - http://www.pismoworld.org/
+ * PISMO memory driver - http://web.archive.org/web/%2A/http://www.pismoworld.org/ 
  *
  * For ARM Realview and Versatile platforms
  *
diff --git a/drivers/mtd/maps/sc520cdp.c b/drivers/mtd/maps/sc520cdp.c
index 85c1e56..c3eb3c0 100644
--- a/drivers/mtd/maps/sc520cdp.c
+++ b/drivers/mtd/maps/sc520cdp.c
@@ -20,7 +20,7 @@
  * The SC520CDP is an evaluation board for the Elan SC520 processor available
  * from AMD. It has two banks of 32-bit Flash ROM, each 8 Megabytes in size,
  * and up to 512 KiB of 8-bit DIL Flash ROM.
- * For details see http://www.amd.com/products/epd/desiging/evalboards/18.elansc520/520_cdp_brief/index.html
+ * For details see http://web.archive.org/web/%2A/http://www.amd.com/products/epd/desiging/evalboards/18.elansc520/520_cdp_brief/index.html 
  */
 
 #include <linux/module.h>
diff --git a/drivers/net/8139too.c b/drivers/net/8139too.c
index f5166dc..721363d 100644
--- a/drivers/net/8139too.c
+++ b/drivers/net/8139too.c
@@ -28,7 +28,7 @@
 		MD 21403
 
 		Support and updates available at
-		http://www.scyld.com/network/rtl8139.html
+		http://web.archive.org/web/%2A/http://www.scyld.com/network/rtl8139.html	
 
 		Twister-tuning table provided by Kinston
 		<shangh-Rasf1IRRPZGoECsaD+WFmw@public.gmane.org>.
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 99fb1f6..c287c76 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -169,9 +169,9 @@ config NET_SB1000
 	  a connection. Further documentation and the necessary scripts can be
 	  found at:
 
-	  <http://www.jacksonville.net/~fventuri/>
-	  <http://home.adelphia.net/~siglercm/sb1000.html>
-	  <http://linuxpower.cx/~cable/>
+	  <http://web.archive.org/web/%2A/http://www.jacksonville.net/~fventuri/>
+	  <http://web.archive.org/web/%2A/http://home.adelphia.net/~siglercm/sb1000.html>
+	  <http://web.archive.org/web/%2A/http://linuxpower.cx/~cable/>
 
 	  If you don't have this card, of course say N.
 
@@ -1552,7 +1552,7 @@ config NATSEMI
 	  which is used in cards from PureData, NetGear, Linksys
 	  and others, including the 83815 chip.
 	  More specific information and updates are available from
-	  <http://www.scyld.com/network/natsemi.html>.
+	  <http://web.archive.org/web/%2A/http://www.scyld.com/network/natsemi.html>.
 
 config NE2K_PCI
 	tristate "PCI NE2000 and clones support (see help)"
@@ -1703,7 +1703,7 @@ config EPIC100
 	  This driver is for the SMC EtherPower II 9432 PCI Ethernet NIC,
 	  which is based on the SMC83c17x (EPIC/100).
 	  More specific information and updates are available from
-	  <http://www.scyld.com/network/epic100.html>.
+	  <http://web.archive.org/web/%2A/http://www.scyld.com/network/epic100.html>.
 
 config SMSC9420
 	tristate "SMSC LAN9420 PCI ethernet adapter support"
@@ -1729,7 +1729,7 @@ config SUNDANCE
 	help
 	  This driver is for the Sundance "Alta" chip.
 	  More specific information and updates are available from
-	  <http://www.scyld.com/network/sundance.html>.
+	  <http://web.archive.org/web/%2A/http://www.scyld.com/network/sundance.html>.
 
 config SUNDANCE_MMIO
 	bool "Use MMIO instead of PIO"
@@ -2201,8 +2201,8 @@ config YELLOWFIN
 	  Say Y here if you have a Packet Engines G-NIC PCI Gigabit Ethernet
 	  adapter or the SYM53C885 Ethernet controller. The Gigabit adapter is
 	  used by the Beowulf Linux cluster project.  See
-	  <http://cesdis.gsfc.nasa.gov/linux/drivers/yellowfin.html> for more
-	  information about this driver in particular and Beowulf in general.
+	  <http://web.archive.org/web/%2A/http://cesdis.gsfc.nasa.gov/linux/drivers/yellowfin.html> 
+	  for more information about this driver in particular and Beowulf in general.
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called yellowfin.  This is recommended.
@@ -3048,7 +3048,7 @@ config PLIP
 	  <file:Documentation/networking/PLIP.txt>.  The cables can be up to
 	  15m long.  Mode 0 works also if one of the machines runs DOS/Windows
 	  and has some PLIP software installed, e.g. the Crynwr PLIP packet
-	  driver (<http://oak.oakland.edu/simtel.net/msdos/pktdrvr-pre.html>)
+	  driver (<http://web.archive.org/web/%2A/http://oak.oakland.edu/simtel.net/msdos/pktdrvr-pre.html>)
 	  and winsock or NCSA's telnet.
 
 	  If you want to use PLIP, say Y and read the PLIP mini-HOWTO as well
diff --git a/drivers/net/acenic.c b/drivers/net/acenic.c
index b9a5916..ecfa01a 100644
--- a/drivers/net/acenic.c
+++ b/drivers/net/acenic.c
@@ -440,7 +440,7 @@ MODULE_PARM_DESC(tx_ratio, "AceNIC/3C985/GA620 ratio of NIC memory used for TX/R
 
 static const char version[] __devinitconst =
   "acenic.c: v0.92 08/05/2002  Jes Sorensen, linux-acenic-j1d+/rmUwOF/SzgSGea1oA@public.gmane.org\n"
-  "                            http://home.cern.ch/~jes/gige/acenic.html\n";
+  "                            http://web.archive.org/web/20071219235833/jes.web.cern.ch/jes/gige/acenic.html\n";
 
 static int ace_get_settings(struct net_device *, struct ethtool_cmd *);
 static int ace_set_settings(struct net_device *, struct ethtool_cmd *);
diff --git a/drivers/net/fealnx.c b/drivers/net/fealnx.c
index d7e8f6b..6d389c1 100644
--- a/drivers/net/fealnx.c
+++ b/drivers/net/fealnx.c
@@ -14,7 +14,7 @@
 	Annapolis MD 21403
 
 	Support information and updates available at
-	http://www.scyld.com/network/pci-skeleton.html
+	http://web.archive.org/web/%2A/http://www.scyld.com/network/pci-skeleton.html	
 
 	Linux kernel updates:
 
diff --git a/drivers/net/hamachi.c b/drivers/net/hamachi.c
index f4523cd..8883d39 100644
--- a/drivers/net/hamachi.c
+++ b/drivers/net/hamachi.c
@@ -19,7 +19,9 @@
 	adapter.
 
 	Support and updates available at
-	http://www.scyld.com/network/hamachi.html
+	http://web.archive.org/web/%2A/http://www.scyld.com/network/hamachi.html
+	or
+	http://web.archive.org/web/%2A/http://www.parl.clemson.edu/~keithu/hamachi.html	
 
 */
 
diff --git a/drivers/net/lne390.c b/drivers/net/lne390.c
index 8a1097c..a154ca4 100644
--- a/drivers/net/lne390.c
+++ b/drivers/net/lne390.c
@@ -23,8 +23,8 @@
 	The shared memory address selection is also slightly different.
 	Note that shared memory address > 1MB are supported with this driver.
 
-	You can try <http://www.mylex.com> if you want more info, as I've
-	never even seen one of these cards.  :)
+	You can try <http://web.archive.org/web/%2A/http://www.mylex.com>
+	if you want more info, as I've never even seen one of these cards.  :)
 
 	Arnaldo Carvalho de Melo <acme-KCZ47A4bww4P48s/oLjRZg@public.gmane.org> - 2000/09/01
 	- get rid of check_region
diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
index a6033d4..cad37c6 100644
--- a/drivers/net/natsemi.c
+++ b/drivers/net/natsemi.c
@@ -19,8 +19,7 @@
 	Annapolis MD 21403
 
 	Support information and updates available at
-	http://www.scyld.com/network/netsemi.html
-	[link no longer provides useful info -jgarzik]
+	http://web.archive.org/web/%2A/http://www.scyld.com/network/netsemi.html	
 
 
 	TODO:
@@ -208,8 +207,8 @@ hardware descriptor ownership, disabling interrupts and NAPI poll scheduling.
 
 IVb. References
 
-http://www.scyld.com/expert/100mbps.html
-http://www.scyld.com/expert/NWay.html
+http://web.archive.org/web/%2A/http://www.scyld.com/expert/100mbps.html
+http://web.archive.org/web/%2A/http://www.scyld.com/expert/NWay.html
 Datasheet is available from:
 http://www.national.com/pf/DP/DP83815.html
 
@@ -223,7 +222,7 @@ None characterised.
 /*
  * Support for fibre connections on Am79C874:
  * This phy needs a special setup when connected to a fibre cable.
- * http://www.amd.com/files/connectivitysolutions/networking/archivednetworking/22235.pdf
+ * http://web.archive.org/web/%2A/http://www.amd.com/files/connectivitysolutions/networking/archivednetworking/22235.pdf 
  */
 #define PHYID_AM79C874	0x0022561b
 
diff --git a/drivers/net/pci-skeleton.c b/drivers/net/pci-skeleton.c
index 627b619..b5819b7 100644
--- a/drivers/net/pci-skeleton.c
+++ b/drivers/net/pci-skeleton.c
@@ -28,7 +28,7 @@
 		MD 21403
 
 		Support and updates available at
-		http://www.scyld.com/network/rtl8139.html
+		http://web.archive.org/web/%2A/http://www.scyld.com/network/rtl8139.html	
 
 		Twister-tuning table provided by Kinston
 		<shangh-Rasf1IRRPZGoECsaD+WFmw@public.gmane.org>.
@@ -79,7 +79,7 @@ that almost all frames will need to be copied to an alignment buffer.
 IVb. References
 
 http://www.realtek.com.tw/
-http://www.scyld.com/expert/NWay.html
+http://web.archive.org/web/%2A/http://www.scyld.com/expert/NWay.html
 
 IVc. Errata
 
diff --git a/drivers/net/starfire.c b/drivers/net/starfire.c
index a42b687..766bb3b 100644
--- a/drivers/net/starfire.c
+++ b/drivers/net/starfire.c
@@ -21,8 +21,7 @@
 	Annapolis MD 21403
 
 	Support and updates available at
-	http://www.scyld.com/network/starfire.html
-	[link no longer provides useful info -jgarzik]
+	http://web.archive.org/web/%2A/http://www.scyld.com/network/starfire.html	
 
 */
 
@@ -282,8 +281,8 @@ IV. Notes
 IVb. References
 
 The Adaptec Starfire manuals, available only from Adaptec.
-http://www.scyld.com/expert/100mbps.html
-http://www.scyld.com/expert/NWay.html
+http://web.archive.org/web/%2A/http://www.scyld.com/expert/100mbps.html
+http://web.archive.org/web/%2A/http://www.scyld.com/expert/NWay.html
 
 IVc. Errata
 
diff --git a/drivers/net/sundance.c b/drivers/net/sundance.c
index 2678588..ee75916 100644
--- a/drivers/net/sundance.c
+++ b/drivers/net/sundance.c
@@ -15,7 +15,7 @@
 	Annapolis MD 21403
 
 	Support and updates available at
-	http://www.scyld.com/network/sundance.html
+	http://web.archive.org/web/%2A/http://www.scyld.com/network/sundance.html	
 	[link no longer provides useful info -jgarzik]
 	Archives of the mailing list are still available at
 	http://www.beowulf.org/pipermail/netdrivers/
@@ -193,8 +193,8 @@ IVb. References
 The Sundance ST201 datasheet, preliminary version.
 The Kendin KS8723 datasheet, preliminary version.
 The ICplus IP100 datasheet, preliminary version.
-http://www.scyld.com/expert/100mbps.html
-http://www.scyld.com/expert/NWay.html
+http://web.archive.org/web/%2A/http://www.scyld.com/expert/100mbps.html
+http://web.archive.org/web/%2A/http://www.scyld.com/expert/NWay.html
 
 IVc. Errata
 
diff --git a/drivers/net/tokenring/Kconfig b/drivers/net/tokenring/Kconfig
index c4137b0..a196b54 100644
--- a/drivers/net/tokenring/Kconfig
+++ b/drivers/net/tokenring/Kconfig
@@ -101,7 +101,7 @@ config TMS380TR
 	  <http://www.tldp.org/docs.html#howto>.
 
 	  Also read the file <file:Documentation/networking/tms380tr.txt> or
-	  check <http://www.auk.cx/tms380tr/>.
+	  check <http://web.archive.org/web/%2A/http://www.auk.cx/tms380tr/>.
 
 	  To compile this driver as a module, choose M here: the module will be
 	  called tms380tr.
diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index 423eb26..7a303e0 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -305,7 +305,7 @@ config DSCC4
 	  DSCC4 chipset.
 
 	  This is supposed to work with the four port card. Take a look at
-	  <http://www.cogenit.fr/dscc4/> for further information about the
+	  <http://web.archive.org/web/%2A/http://www.cogenit.fr/dscc4/> for further information about the
 	  driver.
 
 	  To compile this driver as a module, choose M here: the
@@ -415,9 +415,9 @@ config CYCLADES_SYNC
 
 	  While no documentation is available at this time please grab the
 	  wanconfig tarball in
-	  <http://www.conectiva.com.br/~acme/cycsyn-devel/> (with minor changes
-	  to make it compile with the current wanrouter include files; efforts
-	  are being made to use the original package available at
+	  <http://web.archive.org/web/%2A/http://www.conectiva.com.br/~acme/cycsyn-devel/>
+	  (with minor changes to make it compile with the current wanrouter include files; 
+	  efforts are being made to use the original package available at
 	  <ftp://ftp.sangoma.com/>).
 
 	  Feel free to contact me or the cycsyn-devel mailing list at
@@ -481,8 +481,8 @@ config SBNI
 	  leased line modems.
 
 	  You can find more information and last versions of drivers and
-	  utilities at <http://www.granch.ru/>. If you have any question you
-	  can send email to <sbni-ZmemjH+caRCHXe+LvDLADg@public.gmane.org>.
+	  utilities at <http://web.archive.org/web/%2A/http://www.granch.ru>.
+	  If you have any question you can send email to <sbni-ZmemjH+caRCHXe+LvDLADg@public.gmane.org>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called sbni.
diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index 04c6cd4..55cba46 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -28,7 +28,8 @@
  * Masaryk University (http://www.ics.muni.cz/). The hardware is
  * developed by Jiri Novotny <novotny-8qz54MUs51PtwjQa/ONI9g@public.gmane.org>. More information
  * and the photo of both cards is available at
- * http://www.pavoucek.cz/cosa.html. The card documentation, firmwares
+ * http://web.archive.org/web/20010412025813/http://www.pavoucek.cz/cosa.html 
+ * The card documentation, firmwares
  * and other goods can be downloaded from ftp://ftp.ics.muni.cz/pub/cosa/.
  * For Linux-specific utilities, see below in the "Software info" section.
  * If you want to order the card, contact Jiri Novotny.
diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index e050bd6..2abe321 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -126,8 +126,8 @@ module_param_array(fst_excluded_list, int, NULL, 0);
 /*      The Am186CH/CC processors support a SmartDMA mode using circular pools
  *      of buffer descriptors. The structure is almost identical to that used
  *      in the LANCE Ethernet controllers. Details available as PDF from the
- *      AMD web site: http://www.amd.com/products/epd/processors/\
- *                    2.16bitcont/3.am186cxfa/a21914/21914.pdf
+ *      AMD web site: 
+ *      http://web.archive.org/web/%2A/http://www.amd.com/products/epd/processors/2.16bitcont/3.am186cxfa/a21914/21914.pdf             
  */
 struct txdesc {			/* Transmit descriptor */
 	volatile u16 ladr;	/* Low order address of packet. This is a
diff --git a/drivers/net/wan/sbni.c b/drivers/net/wan/sbni.c
index cff13a9..e8e77e9 100644
--- a/drivers/net/wan/sbni.c
+++ b/drivers/net/wan/sbni.c
@@ -8,7 +8,7 @@
  *	Driver supports SBNI12-02,-04,-05,-10,-11 cards, single and
  *	double-channel, PCI and ISA modifications.
  *	More info and useful utilities to work with SBNI12 cards you can find
- *	at http://www.granch.com (English) or http://www.granch.ru (Russian)
+ *	at http://web.archive.org/web/%2A/http://www.granch.com 
  *
  *	This software may be used and distributed according to the terms
  *	of the GNU General Public License.
diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index 69a9b34..b2e300d 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -25,7 +25,7 @@
  * 802.11 (802.11e mostly) papers and by reading various public available
  * Atheros presentations and papers like these:
  *
- * 5210 - http://nova.stanford.edu/~bbaas/ps/isscc2002_slides.pdf
+ * 5210 - http://web.archive.org/web/%2A/http://nova.stanford.edu/~bbaas/ps/isscc2002_slides.pdf 
  *
  * 5211 - http://www.hotchips.org/archives/hc14/3_Tue/16_mcfarland.pdf
  *
diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index ba54d1b..6ce7d7e 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -215,7 +215,7 @@ static int prism2_pccard_card_present(local_info_t *local)
 /*
  * SanDisk CompactFlash WLAN Flashcard - Product Manual v1.0
  * Document No. 20-10-00058, January 2004
- * http://www.sandisk.com/pdf/industrial/ProdManualCFWLANv1.0.pdf
+ * http://web.archive.org/web/%2A/http://www.sandisk.com/pdf/industrial/ProdManualCFWLANv1.0.pdf 
  */
 #define SANDISK_WLAN_ACTIVATION_OFF 0x40
 #define SANDISK_HCR_OFF 0x42
diff --git a/drivers/parport/Kconfig b/drivers/parport/Kconfig
index 855f389..3017185 100644
--- a/drivers/parport/Kconfig
+++ b/drivers/parport/Kconfig
@@ -18,8 +18,8 @@ menuconfig PARPORT
 	  <file:drivers/parport/BUGS-parport>.
 
 	  For extensive information about drivers for many devices attaching
-	  to the parallel port see <http://www.torque.net/linux-pp.html> on
-	  the WWW.
+	  to the parallel port see 
+	  <http://web.archive.org/web/%2A/http://www.torque.net/linux-pp.html>
 
 	  It is possible to share a single parallel port among several devices
 	  and it is safe to compile all the corresponding drivers into the
diff --git a/drivers/scsi/arm/Kconfig b/drivers/scsi/arm/Kconfig
index a8587f1..53c645a 100644
--- a/drivers/scsi/arm/Kconfig
+++ b/drivers/scsi/arm/Kconfig
@@ -39,7 +39,7 @@ config SCSI_ARXESCSI
 	  HD discs from the then new A5000 on earlier models. This interface
 	  was either sold on its own or with an integral SCSI controller.
 	  Technical details on this NCR53c94-based device are available at
-	  <http://www.cryton.demon.co.uk/acornbits/scsi_arxe.html>
+	  <http://web.archive.org/web/%2A/http://www.cryton.demon.co.uk/acornbits/scsi_arxe.html>
 	  Say Y here to compile in support for the SCSI controller.
 
 config SCSI_CUMANA_2
diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index 9a4b69d..d435686 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -7,8 +7,8 @@
  See the file Documentation/scsi/ibmmca.txt for a detailed description
  of this driver, the commandline arguments and the history of its
  development.
- See the WWW-page: http://www.uni-mainz.de/~langm000/linux.html for latest
- updates, info and ADF-files for adapters supported by this driver.
+ See the WWW-page: http://web.archive.org/web/%2A/http://www.uni-mainz.de/~langm000/linux.html
+ for latest updates, info and ADF-files for adapters supported by this driver.
 
  Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
  Updated for Linux 2.5.45 to use the new error handler, cleaned up the
diff --git a/drivers/serial/altera_uart.c b/drivers/serial/altera_uart.c
index f8d8a00..8e8ba66 100644
--- a/drivers/serial/altera_uart.c
+++ b/drivers/serial/altera_uart.c
@@ -30,7 +30,7 @@
 
 /*
  * Altera UART register definitions according to the Nios UART datasheet:
- * http://www.altera.com/literature/ds/ds_nios_uart.pdf
+ * http://web.archive.org/web/%2A/http://www.altera.com/literature/ds/ds_nios_uart.pdf 
  */
 
 #define ALTERA_UART_SIZE		32
diff --git a/drivers/serial/sn_console.c b/drivers/serial/sn_console.c
index cff9a30..f7edc78 100644
--- a/drivers/serial/sn_console.c
+++ b/drivers/serial/sn_console.c
@@ -34,7 +34,7 @@
  *
  * For further information regarding this notice, see:
  *
- * http://oss.sgi.com/projects/GenInfo/NoticeExplan
+ * http://web.archive.org/web/%2A/http://oss.sgi.com/projects/GenInfo/NoticeExplan 
  */
 
 #include <linux/interrupt.h>
diff --git a/drivers/staging/comedi/drivers/c6xdigio.c b/drivers/staging/comedi/drivers/c6xdigio.c
index e0ac825..aca9f51 100644
--- a/drivers/staging/comedi/drivers/c6xdigio.c
+++ b/drivers/staging/comedi/drivers/c6xdigio.c
@@ -2,7 +2,7 @@
    comedi/drivers/c6xdigio.c
 
    Hardware driver for Mechatronic Systems Inc. C6x_DIGIO DSP daughter card.
-   (http://robot0.ge.uiuc.edu/~spong/mecha/)
+   (http://web.archive.org/web/%2A/http://robot0.ge.uiuc.edu/~spong/mecha/)
 
    COMEDI - Linux Control and Measurement Device Interface
    Copyright (C) 1999 Dan Block
@@ -31,7 +31,7 @@ Devices: [Mechatronic Systems Inc.] C6x_DIGIO DSP daughter card (c6xdigio)
 Updated: Sun Nov 20 20:18:34 EST 2005
 
 This driver will not work with a 2.4 kernel.
-http://robot0.ge.uiuc.edu/~spong/mecha/
+http://web.archive.org/web/%2A/http://robot0.ge.uiuc.edu/~spong/mecha/
 
 */
 
diff --git a/drivers/staging/comedi/drivers/pcl711.c b/drivers/staging/comedi/drivers/pcl711.c
index b44386a..b86dda1 100644
--- a/drivers/staging/comedi/drivers/pcl711.c
+++ b/drivers/staging/comedi/drivers/pcl711.c
@@ -41,7 +41,7 @@ supported.
    driver for the PCL-711.  I used a few ideas from his driver
    here.  His driver also has more comments, if you are
    interested in understanding how this driver works.
-   http://tech.buffalostate.edu/~dave/driver/
+   http://web.archive.org/web/%2A/http://tech.buffalostate.edu/~dave/driver/ 
 
    The ACL-8112 driver was hacked from the sources of the PCL-711
    driver (the 744 chip used on the 8112 is almost the same as
diff --git a/drivers/staging/go7007/go7007.txt b/drivers/staging/go7007/go7007.txt
index 06a76da..21a487c 100644
--- a/drivers/staging/go7007/go7007.txt
+++ b/drivers/staging/go7007/go7007.txt
@@ -415,10 +415,10 @@ in the TDA8290/TDA8275 tuner driver.
 The following patches must be downloaded from Gerd Knorr's website and
 applied in the order listed:
 
-	http://dl.bytesex.org/patches/2.6.11-2/i2c-tuner
-	http://dl.bytesex.org/patches/2.6.11-2/i2c-tuner2
-	http://dl.bytesex.org/patches/2.6.11-2/v4l2-api-mpeg
-	http://dl.bytesex.org/patches/2.6.11-2/saa7134-update
+	http://web.archive.org/web/%2A/http://dl.bytesex.org/patches/2.6.11-2/i2c-tuner	
+	http://web.archive.org/web/%2A/http://dl.bytesex.org/patches/2.6.11-2/i2c-tuner2
+	http://web.archive.org/web/%2A/http://dl.bytesex.org/patches/2.6.11-2/v4l2-api-mpeg
+	http://web.archive.org/web/%2A/http://dl.bytesex.org/patches/2.6.11-2/saa7134-update
 
 The following patches are included with this SDK and can be applied in any
 order:
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index f5d0674..1eca35d 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -14,7 +14,7 @@
  * See Documentation/usb/usb-serial.txt for more information on using this
  * driver
  *
- * See http://geocities.com/i0xox0i for information on this driver and the
+ * See http://web.archive.org/web/%2A/http://geocities.com/i0xox0i for information on this driver and the
  * earthmate usb device.
  *
  *  Lonnie Mendez <dignome-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 2c897ee..eac1adf 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -962,7 +962,7 @@ UNUSUAL_DEV(  0x07af, 0x0006, 0x0100, 0x0100,
  * Only revision 1.13 tested (same for all of the above devices,
  * based on the Datafab DF-UG-07 chip).  Needed for US_FL_FIX_INQUIRY.
  * Submitted by Marek Michalkiewicz <marekm-HuSaFJn/uQtscumT1wHf3A@public.gmane.org>.
- * See also http://martin.wilck.bei.t-online.de/#kecf .
+ * See also http://web.archive.org/web/20030808203106/http://martin.wilck.bei.t-online.de/ .
  */
 UNUSUAL_DEV(  0x07c4, 0xa400, 0x0000, 0xffff,
 		"Datafab",
diff --git a/drivers/video/macfb.c b/drivers/video/macfb.c
index 43207cc..6cc8363 100644
--- a/drivers/video/macfb.c
+++ b/drivers/video/macfb.c
@@ -16,7 +16,7 @@
  * Jacobowitz, Paul Mackerras, Fabio Riccardi, and Geert Uytterhoeven.
  *
  * The VideoToolbox "Bugs" web page at
- * http://rajsky.psych.nyu.edu/Tips/VideoBugs.html
+ * http://web.archive.org/web/%2A/http://rajsky.psych.nyu.edu/Tips/VideoBugs.html 
  *
  * This code is free software.  You may copy, modify, and distribute
  * it subject to the terms and conditions of the GNU General Public
diff --git a/drivers/video/s3fb.c b/drivers/video/s3fb.c
index dce8c97..fa121b6 100644
--- a/drivers/video/s3fb.c
+++ b/drivers/video/s3fb.c
@@ -7,7 +7,7 @@
  * License.  See the file COPYING in the main directory of this archive for
  * more details.
  *
- * Code is based on David Boucher's viafb (http://davesdomain.org.uk/viafb/)
+ * Code is based on David Boucher's viafb (http://web.archive.org/web/%2A/http://davesdomain.org.uk/viafb/)
  * which is based on the code of neofb.
  */
 
diff --git a/drivers/video/svgalib.c b/drivers/video/svgalib.c
index fdb4567..b4c87d0 100644
--- a/drivers/video/svgalib.c
+++ b/drivers/video/svgalib.c
@@ -7,7 +7,7 @@
  * License.  See the file COPYING in the main directory of this archive for
  * more details.
  *
- * Some parts are based on David Boucher's viafb (http://davesdomain.org.uk/viafb/)
+ * Some parts are based on David Boucher's viafb (http://web.archive.org/web/20071125103157/http://davesdomain.org.uk/viafb/)
  */
 
 #include <linux/module.h>
diff --git a/drivers/video/vt8623fb.c b/drivers/video/vt8623fb.c
index 85d76ec..d77d725 100644
--- a/drivers/video/vt8623fb.c
+++ b/drivers/video/vt8623fb.c
@@ -9,7 +9,7 @@
  * more details.
  *
  * Code is based on s3fb, some parts are from David Boucher's viafb
- * (http://davesdomain.org.uk/viafb/)
+ * (http://web.archive.org/web/%2A/http://davesdomain.org.uk/viafb/)
  */
 
 #include <linux/module.h>
diff --git a/drivers/watchdog/pcwd.c b/drivers/watchdog/pcwd.c
index 06f7922..0f8b2d7 100644
--- a/drivers/watchdog/pcwd.c
+++ b/drivers/watchdog/pcwd.c
@@ -46,7 +46,7 @@
  */
 
 /*
- *	A bells and whistles driver is available from http://www.pcwd.de/
+ *	A bells and whistles driver is available from http://web.archive.org/web/%2A/http://www.pcwd.de/ 
  *	More info available at http://www.berkprod.com/ or
  *	http://www.pcwatchdog.com/
  */
diff --git a/fs/ncpfs/Kconfig b/fs/ncpfs/Kconfig
index c931cf2..15cf9cf 100644
--- a/fs/ncpfs/Kconfig
+++ b/fs/ncpfs/Kconfig
@@ -17,7 +17,8 @@ config NCP_FS
 	  file *server* for Novell NetWare clients.
 
 	  General information about how to connect Linux, Windows machines and
-	  Macs is on the WWW at <http://www.eats.com/linux_mac_win.html>.
+	  Macs is on the WWW at
+	  <http://web.archive.org/web/20011204193118/http://www.eats.com/linux_mac_win.html>.
 
 	  To compile this as a module, choose M here: the module will be called
 	  ncpfs.  Say N unless you are connected to a Novell network.
diff --git a/fs/nls/Kconfig b/fs/nls/Kconfig
index a39edc4..4322501 100644
--- a/fs/nls/Kconfig
+++ b/fs/nls/Kconfig
@@ -416,7 +416,7 @@ config NLS_ISO8859_14
 	  input/output character sets. Say Y here for the Latin 8 character
 	  set, which adds the last accented vowels for Welsh (aka Cymraeg)
 	  (and Manx Gaelic) that were missing in Latin 1.
-	  <http://linux.speech.cymru.org/> has further information.
+	  <http://web.archive.org/web/%2A/http://linux.speech.cymru.org> has further information.
 
 config NLS_ISO8859_15
 	tristate "NLS ISO 8859-15 (Latin 9; Western European Languages with Euro)"
diff --git a/fs/nls/nls_base.c b/fs/nls/nls_base.c
index 44a88a9..7ef7118 100644
--- a/fs/nls/nls_base.c
+++ b/fs/nls/nls_base.c
@@ -23,7 +23,7 @@ static DEFINE_SPINLOCK(nls_lock);
 
 /*
  * Sample implementation from Unicode home page.
- * http://www.stonehand.com/unicode/standard/fss-utf.html
+ * http://web.archive.org/web/19970105220809/http://stonehand.com/unicode/standard/fss-utf.html 
  */
 struct utf8_table {
 	int     cmask;
diff --git a/fs/reiserfs/procfs.c b/fs/reiserfs/procfs.c
index 7a99811..37b40fa 100644
--- a/fs/reiserfs/procfs.c
+++ b/fs/reiserfs/procfs.c
@@ -555,13 +555,13 @@ int reiserfs_proc_info_global_done(void)
  *  . remove remove_save_link() from reiserfs_do_truncate()
  *
  * I accept terms and conditions stated in the Legal Agreement
- * (available at http://www.namesys.com/legalese.html)
+ * (available at http://web.archive.org/web/%2A/http://www.namesys.com/legalese.html)
  *
  * Revision 1.1.8.1  2001/07/11 16:48:50  god
  * proc info support
  *
  * I accept terms and conditions stated in the Legal Agreement
- * (available at http://www.namesys.com/legalese.html)
+ * (available at http://web.archive.org/web/%2A/http://www.namesys.com/legalese.html)
  *
  */
 
diff --git a/include/linux/edd.h b/include/linux/edd.h
index 4cbd0fe..557227c 100644
--- a/include/linux/edd.h
+++ b/include/linux/edd.h
@@ -6,8 +6,9 @@
  * structures and definitions for the int 13h, ax={41,48}h
  * BIOS Enhanced Disk Drive Services
  * This is based on the T13 group document D1572 Revision 0 (August 14 2002)
- * available at http://www.t13.org/docs2002/d1572r0.pdf.  It is
- * very similar to D1484 Revision 3 http://www.t13.org/docs2002/d1484r3.pdf
+ * available at http://web.archive.org/web/%2A/http://www.t13.org/docs2002/d1572r0.pdf.
+ * It is very similar to D1484 Revision 3 
+ * http://web.archive.org/web/%2A/http://www.t13.org/docs2002/d1484r3.pdf
  *
  * In a nutshell, arch/{i386,x86_64}/boot/setup.S populates a scratch
  * table in the boot_params that contains a list of BIOS-enumerated
diff --git a/include/linux/mtd/pismo.h b/include/linux/mtd/pismo.h
index 8dfb7e1..c2d6e75 100644
--- a/include/linux/mtd/pismo.h
+++ b/include/linux/mtd/pismo.h
@@ -1,5 +1,5 @@
 /*
- * PISMO memory driver - http://www.pismoworld.org/
+ * PISMO memory driver - http://web.archive.org/web/%2A/http://www.pismoworld.org/ 
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index a9f3c6f..19d4d85 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -16,7 +16,7 @@ Version 2 and 3 extensions to driver:
     Version: 3.5.34 (20060920)
     This version is for 2.6 series kernels.
 
-    For a full changelog see http://www.torque.net/sg
+    For a full changelog see http://web.archive.org/web/%2A/http://www.torque.net/sg 
 
 Map of SG verions to the Linux kernels in which they appear:
        ----------        ----------------------------------
@@ -52,17 +52,17 @@ Major new features in SG 3.x driver (cf SG 2.x drivers)
  Documentation
  =============
  A web site for the SG device driver can be found at:
-	http://www.torque.net/sg  [alternatively check the MAINTAINERS file]
+	http://web.archive.org/web/%2A/http://www.torque.net/sg	
  The documentation for the sg version 3 driver can be found at:
- 	http://www.torque.net/sg/p/sg_v3_ho.html
+ 	http://web.archive.org/web/%2A/http://www.torque.net/sg/p/sg_v3_ho.html
  This is a rendering from DocBook source [change the extension to "sgml"
  or "xml"]. There are renderings in "ps", "pdf", "rtf" and "txt" (soon).
  The SG_IO ioctl is now found in other parts kernel (e.g. the block layer).
  For more information see http://www.torque.net/sg/sg_io.html
 
  The older, version 2 documents discuss the original sg interface in detail:
-	http://www.torque.net/sg/p/scsi-generic.txt
-	http://www.torque.net/sg/p/scsi-generic_long.txt
+	http://web.archive.org/web/%2A/http://www.torque.net/sg/p/scsi-generic.txt
+	http://web.archive.org/web/%2A/http://www.torque.net/sg/p/scsi-generic_long.txt
  Also available: <kernel_source>/Documentation/scsi/scsi-generic.txt
 
  Utility and test programs are available at the sg web site. They are 
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index a90050d..7defdc3 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -271,8 +271,8 @@ config IP_PIMSM_V1
 	  Kernel side support for Sparse Mode PIM (Protocol Independent
 	  Multicast) version 1. This multicast routing protocol is used widely
 	  because Cisco supports it. You need special software to use it
-	  (pimd-v1). Please see <http://netweb.usc.edu/pim/> for more
-	  information about PIM.
+	  (pimd-v1). Please see <http://web.archive.org/web/%2A/http://netweb.usc.edu/pim/> 
+	  for more information about PIM.
 
 	  Say Y if you want to use PIM-SM v1. Note that you can say N here if
 	  you just want to use Dense Mode PIM.
diff --git a/net/ipv4/tcp_illinois.c b/net/ipv4/tcp_illinois.c
index d84140c..e8448e3 100644
--- a/net/ipv4/tcp_illinois.c
+++ b/net/ipv4/tcp_illinois.c
@@ -1,7 +1,7 @@
 /*
  * TCP Illinois congestion control.
  * Home page:
- *	http://www.ews.uiuc.edu/~shaoliu/tcpillinois/index.html
+ *	http://web.archive.org/web/%2A/http://www.ews.uiuc.edu/~shaoliu/tcpillinois/index.html	
  *
  * The algorithm is described in:
  * "TCP-Illinois: A Loss and Delay-Based Congestion Control Algorithm
diff --git a/net/ipv4/tcp_lp.c b/net/ipv4/tcp_lp.c
index de87037..b88c17b 100644
--- a/net/ipv4/tcp_lp.c
+++ b/net/ipv4/tcp_lp.c
@@ -22,7 +22,7 @@
  * Original Author:
  *   Aleksandar Kuzmanovic <akuzma-angj7XTnwNpXfO9P/gJGhg@public.gmane.org>
  * Available from:
- *   http://www.ece.rice.edu/~akuzma/Doc/akuzma/TCP-LP.pdf
+ *   http://web.archive.org/web/%2A/http://www.ece.rice.edu/~akuzma/Doc/akuzma/TCP-LP.pdf 
  * Original implementation for 2.4.19:
  *   http://www-ece.rice.edu/networks/TCP-LP/
  *
diff --git a/sound/isa/Kconfig b/sound/isa/Kconfig
index c6990c6..1f41e97 100644
--- a/sound/isa/Kconfig
+++ b/sound/isa/Kconfig
@@ -421,7 +421,7 @@ config SND_MSND_CLASSIC
 	  See <file:Documentation/sound/oss/MultiSound> for important information
 	  about this driver.  Note that it has been discontinued, but the
 	  Voyetra Turtle Beach knowledge base entry for it is still available
-	  at <http://www.turtlebeach.com/site/kb_ftp/790.asp>.
+	  at <http://web.archive.org/web/20050407083114/http://www.turtlebeach.com/site/kb_ftp/790.asp>.
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called snd-msnd-classic.
diff --git a/sound/isa/cmi8330.c b/sound/isa/cmi8330.c
index fe79a16..64c936c 100644
--- a/sound/isa/cmi8330.c
+++ b/sound/isa/cmi8330.c
@@ -1,7 +1,7 @@
 /*
  *  Driver for C-Media's CMI8330 and CMI8329 soundcards.
  *  Copyright (c) by George Talusan <gstalusan-QFUY5ocGksJFJ04o6PK0Fg@public.gmane.org>
- *    http://www.undergrad.math.uwaterloo.ca/~gstalusa
+ *   http://web.archive.org/web/%2A/http://www.undergrad.math.uwaterloo.ca/~gstalusa 
  *
  *   This program is free software; you can redistribute it and/or modify
  *   it under the terms of the GNU General Public License as published by
diff --git a/sound/oss/Kconfig b/sound/oss/Kconfig
index a513651..3db52d3 100644
--- a/sound/oss/Kconfig
+++ b/sound/oss/Kconfig
@@ -36,7 +36,7 @@ config SOUND_MSNDCLAS
 	  See <file:Documentation/sound/oss/MultiSound> for important information
 	  about this driver.  Note that it has been discontinued, but the
 	  Voyetra Turtle Beach knowledge base entry for it is still available
-	  at <http://www.turtlebeach.com/site/kb_ftp/790.asp>.
+	  at <http://web.archive.org/web/%2A/http://www.undergrad.math.uwaterloo.ca/~gstalusa>.
 
 comment "Compiled-in MSND Classic support requires firmware during compilation."
 	depends on SOUND_PRIME && SOUND_MSNDCLAS=y
@@ -98,7 +98,7 @@ config SOUND_MSNDPIN
 	  See <file:Documentation/sound/oss/MultiSound> for important information
 	  about this driver. Note that it has been discontinued, but the
 	  Voyetra Turtle Beach knowledge base entry for it is still available
-	  at <http://www.turtlebeach.com/site/kb_ftp/600.asp>.
+	  at <http://web.archive.org/web/%2A/http://www.turtlebeach.com/site/kb_ftp/600.asp>.
 
 comment "Compiled-in MSND Pinnacle support requires firmware during compilation."
 	depends on SOUND_PRIME && SOUND_MSNDPIN=y
diff --git a/sound/pci/ac97/ac97_patch.c b/sound/pci/ac97/ac97_patch.c
index e68c98e..de4641c 100644
--- a/sound/pci/ac97/ac97_patch.c
+++ b/sound/pci/ac97/ac97_patch.c
@@ -3874,7 +3874,7 @@ static int patch_lm4550(struct snd_ac97 *ac97)
 }
 
 /* 
- *  UCB1400 codec (http://www.semiconductors.philips.com/acrobat_download/datasheets/UCB1400-02.pdf)
+ *  UCB1400 codec (http://web.archive.org/web/%2A/http://www.semiconductors.philips.com/acrobat_download/datasheets/UCB1400-02.pdf)
  */
 static const struct snd_kcontrol_new snd_ac97_controls_ucb1400[] = {
 /* enable/disable headphone driver which allows direct connection to
diff --git a/sound/pci/nm256/nm256.c b/sound/pci/nm256/nm256.c
index 5a60492..90c36a4 100644
--- a/sound/pci/nm256/nm256.c
+++ b/sound/pci/nm256/nm256.c
@@ -6,7 +6,7 @@
  * The original author of OSS nm256 driver wishes to remain anonymous,
  * so I just put my acknoledgment to him/her here.
  * The original author's web page is found at
- *	http://www.uglx.org/sony.html
+ *	http://web.archive.org/web/%2A/http://www.uglx.org/sony.html	
  *
  *
  *   This program is free software; you can redistribute it and/or modify
-- 
1.7.2.1

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

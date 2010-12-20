From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 7/7] [SCSI] tgt: Defconfig cleanup.
Date: Mon, 20 Dec 2010 18:50:35 +0100
Message-ID: <201012201850.35957.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:51151 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742Ab0LTSUK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2010 13:20:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>, Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: scst-devel@lists.sourceforge.net, James.Bottomley@suse.de



Because of the removal of the scsi_tgt kernel module, the kbuild variables
CONFIG_SCSI_TGT, CONFIG_SCSI_SRP_TGT_ATTRS and CONFIG_SCSI_FC_TGT_ATTRS
are obsolete. This patch removes these variables. This patch is the result
of the following command:

find -name '*defconfig' | while read f; do grep -vwE 'CONFIG_SCSI_TGT|CONFIG_SCSI_SRP_TGT_ATTRS|CONFIG_SCSI_FC_TGT_ATTRS' $f >/tmp/t && mv /tmp/t $f; done

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Brian King <brking@linux.vnet.ibm.com>
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
---
 arch/arm/configs/at572d940hfek_defconfig         |    1 -
 arch/arm/configs/cam60_defconfig                 |    1 -
 arch/arm/configs/s3c2410_defconfig               |    1 -
 arch/m68k/configs/amiga_defconfig                |    2 --
 arch/m68k/configs/apollo_defconfig               |    2 --
 arch/m68k/configs/atari_defconfig                |    2 --
 arch/m68k/configs/bvme6000_defconfig             |    2 --
 arch/m68k/configs/hp300_defconfig                |    2 --
 arch/m68k/configs/mac_defconfig                  |    2 --
 arch/m68k/configs/multi_defconfig                |    2 --
 arch/m68k/configs/mvme147_defconfig              |    2 --
 arch/m68k/configs/mvme16x_defconfig              |    2 --
 arch/m68k/configs/q40_defconfig                  |    2 --
 arch/m68k/configs/sun3_defconfig                 |    2 --
 arch/m68k/configs/sun3x_defconfig                |    2 --
 arch/mips/configs/bcm47xx_defconfig              |    1 -
 arch/mips/configs/decstation_defconfig           |    1 -
 arch/mips/configs/ip22_defconfig                 |    1 -
 arch/mips/configs/ip27_defconfig                 |    1 -
 arch/mips/configs/ip32_defconfig                 |    1 -
 arch/mips/configs/jazz_defconfig                 |    1 -
 arch/mips/configs/malta_defconfig                |    1 -
 arch/mips/configs/markeins_defconfig             |    1 -
 arch/mips/configs/pnx8550-jbs_defconfig          |    1 -
 arch/mips/configs/pnx8550-stb810_defconfig       |    1 -
 arch/mips/configs/rm200_defconfig                |    1 -
 arch/mips/configs/tb0226_defconfig               |    1 -
 arch/mips/configs/tb0287_defconfig               |    1 -
 arch/powerpc/configs/52xx/motionpro_defconfig    |    1 -
 arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig |    1 -
 arch/powerpc/configs/mpc5200_defconfig           |    1 -
 arch/powerpc/configs/ppc6xx_defconfig            |    1 -
 arch/sh/configs/sh2007_defconfig                 |    1 -
 33 files changed, 0 insertions(+), 45 deletions(-)

diff --git a/arch/arm/configs/at572d940hfek_defconfig b/arch/arm/configs/at572d940hfek_defconfig
index 695e32d..08d49f0 100644
--- a/arch/arm/configs/at572d940hfek_defconfig
+++ b/arch/arm/configs/at572d940hfek_defconfig
@@ -107,7 +107,6 @@ CONFIG_SENSORS_TSL2550=m
 CONFIG_DS1682=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=m
-CONFIG_SCSI_TGT=m
 # CONFIG_SCSI_PROC_FS is not set
 CONFIG_BLK_DEV_SD=m
 CONFIG_BLK_DEV_SR=m
diff --git a/arch/arm/configs/cam60_defconfig b/arch/arm/configs/cam60_defconfig
index cedc92e..cfed41a 100644
--- a/arch/arm/configs/cam60_defconfig
+++ b/arch/arm/configs/cam60_defconfig
@@ -55,7 +55,6 @@ CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 # CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_CHR_DEV_SCH=y
diff --git a/arch/arm/configs/s3c2410_defconfig b/arch/arm/configs/s3c2410_defconfig
index f9096c1..c580691 100644
--- a/arch/arm/configs/s3c2410_defconfig
+++ b/arch/arm/configs/s3c2410_defconfig
@@ -229,7 +229,6 @@ CONFIG_BLK_DEV_IDECD=y
 CONFIG_BLK_DEV_IDETAPE=m
 CONFIG_BLK_DEV_PLATFORM=y
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=m
diff --git a/arch/m68k/configs/amiga_defconfig b/arch/m68k/configs/amiga_defconfig
index dbb49fc..233ea6c 100644
--- a/arch/m68k/configs/amiga_defconfig
+++ b/arch/m68k/configs/amiga_defconfig
@@ -165,7 +165,6 @@ CONFIG_BLK_DEV_GAYLE=y
 CONFIG_BLK_DEV_BUDDHA=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
@@ -176,7 +175,6 @@ CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_LIBSAS=m
 # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_ISCSI_TCP=m
 CONFIG_A3000_SCSI=y
 CONFIG_A2091_SCSI=y
diff --git a/arch/m68k/configs/apollo_defconfig b/arch/m68k/configs/apollo_defconfig
index 562b221..285fb10 100644
--- a/arch/m68k/configs/apollo_defconfig
+++ b/arch/m68k/configs/apollo_defconfig
@@ -155,7 +155,6 @@ CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
@@ -166,7 +165,6 @@ CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_LIBSAS=m
 # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_ISCSI_TCP=m
 CONFIG_MD=y
 CONFIG_BLK_DEV_MD=m
diff --git a/arch/m68k/configs/atari_defconfig b/arch/m68k/configs/atari_defconfig
index 82978df..7919ab4 100644
--- a/arch/m68k/configs/atari_defconfig
+++ b/arch/m68k/configs/atari_defconfig
@@ -160,7 +160,6 @@ CONFIG_BLK_DEV_IDECD=y
 CONFIG_BLK_DEV_FALCON_IDE=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
@@ -171,7 +170,6 @@ CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_LIBSAS=m
 # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_ISCSI_TCP=m
 CONFIG_ATARI_SCSI=y
 CONFIG_MD=y
diff --git a/arch/m68k/configs/bvme6000_defconfig b/arch/m68k/configs/bvme6000_defconfig
index 67bb6fc..19fd7e8 100644
--- a/arch/m68k/configs/bvme6000_defconfig
+++ b/arch/m68k/configs/bvme6000_defconfig
@@ -153,7 +153,6 @@ CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
@@ -164,7 +163,6 @@ CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_LIBSAS=m
 # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_ISCSI_TCP=m
 CONFIG_BVME6000_SCSI=y
 CONFIG_MD=y
diff --git a/arch/m68k/configs/hp300_defconfig b/arch/m68k/configs/hp300_defconfig
index 3e35ce5..a64b226 100644
--- a/arch/m68k/configs/hp300_defconfig
+++ b/arch/m68k/configs/hp300_defconfig
@@ -154,7 +154,6 @@ CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
@@ -165,7 +164,6 @@ CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_LIBSAS=m
 # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_ISCSI_TCP=m
 CONFIG_MD=y
 CONFIG_BLK_DEV_MD=m
diff --git a/arch/m68k/configs/mac_defconfig b/arch/m68k/configs/mac_defconfig
index ae81e2d..3a0c17b 100644
--- a/arch/m68k/configs/mac_defconfig
+++ b/arch/m68k/configs/mac_defconfig
@@ -157,7 +157,6 @@ CONFIG_BLK_DEV_IDECD=y
 CONFIG_BLK_DEV_MAC_IDE=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
@@ -168,7 +167,6 @@ CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_LIBSAS=m
 # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_ISCSI_TCP=m
 CONFIG_MAC_SCSI=y
 CONFIG_SCSI_MAC_ESP=y
diff --git a/arch/m68k/configs/multi_defconfig b/arch/m68k/configs/multi_defconfig
index ad9e857..658e599 100644
--- a/arch/m68k/configs/multi_defconfig
+++ b/arch/m68k/configs/multi_defconfig
@@ -188,7 +188,6 @@ CONFIG_BLK_DEV_MAC_IDE=y
 CONFIG_BLK_DEV_Q40IDE=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
@@ -199,7 +198,6 @@ CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_LIBSAS=m
 # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_ISCSI_TCP=m
 CONFIG_A3000_SCSI=y
 CONFIG_A2091_SCSI=y
diff --git a/arch/m68k/configs/mvme147_defconfig b/arch/m68k/configs/mvme147_defconfig
index af77374..14d7762 100644
--- a/arch/m68k/configs/mvme147_defconfig
+++ b/arch/m68k/configs/mvme147_defconfig
@@ -152,7 +152,6 @@ CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
@@ -163,7 +162,6 @@ CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_LIBSAS=m
 # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_ISCSI_TCP=m
 CONFIG_MVME147_SCSI=y
 CONFIG_MD=y
diff --git a/arch/m68k/configs/mvme16x_defconfig b/arch/m68k/configs/mvme16x_defconfig
index c45aaf3..a77c1b6 100644
--- a/arch/m68k/configs/mvme16x_defconfig
+++ b/arch/m68k/configs/mvme16x_defconfig
@@ -153,7 +153,6 @@ CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
@@ -164,7 +163,6 @@ CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_LIBSAS=m
 # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_ISCSI_TCP=m
 CONFIG_MVME16x_SCSI=y
 CONFIG_MD=y
diff --git a/arch/m68k/configs/q40_defconfig b/arch/m68k/configs/q40_defconfig
index 46bed78..b451d75 100644
--- a/arch/m68k/configs/q40_defconfig
+++ b/arch/m68k/configs/q40_defconfig
@@ -152,7 +152,6 @@ CONFIG_BLK_DEV_IDECD=y
 CONFIG_BLK_DEV_Q40IDE=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
@@ -163,7 +162,6 @@ CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_LIBSAS=m
 # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_ISCSI_TCP=m
 CONFIG_MD=y
 CONFIG_BLK_DEV_MD=m
diff --git a/arch/m68k/configs/sun3_defconfig b/arch/m68k/configs/sun3_defconfig
index 86f7772..02a3b06 100644
--- a/arch/m68k/configs/sun3_defconfig
+++ b/arch/m68k/configs/sun3_defconfig
@@ -150,7 +150,6 @@ CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
@@ -161,7 +160,6 @@ CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_LIBSAS=m
 # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_ISCSI_TCP=m
 CONFIG_SUN3_SCSI=y
 CONFIG_MD=y
diff --git a/arch/m68k/configs/sun3x_defconfig b/arch/m68k/configs/sun3x_defconfig
index 2882614..1329178 100644
--- a/arch/m68k/configs/sun3x_defconfig
+++ b/arch/m68k/configs/sun3x_defconfig
@@ -150,7 +150,6 @@ CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
@@ -161,7 +160,6 @@ CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_LIBSAS=m
 # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_ISCSI_TCP=m
 CONFIG_SUN3X_ESP=y
 CONFIG_MD=y
diff --git a/arch/mips/configs/bcm47xx_defconfig b/arch/mips/configs/bcm47xx_defconfig
index 927d58b..730b9d8 100644
--- a/arch/mips/configs/bcm47xx_defconfig
+++ b/arch/mips/configs/bcm47xx_defconfig
@@ -293,7 +293,6 @@ CONFIG_BLK_DEV_RAM_SIZE=16384
 CONFIG_ATA_OVER_ETH=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
diff --git a/arch/mips/configs/decstation_defconfig b/arch/mips/configs/decstation_defconfig
index b15bfd1..ba9cc5f 100644
--- a/arch/mips/configs/decstation_defconfig
+++ b/arch/mips/configs/decstation_defconfig
@@ -45,7 +45,6 @@ CONFIG_VLAN_8021Q=m
 CONFIG_CONNECTOR=m
 CONFIG_BLK_DEV_LOOP=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=m
diff --git a/arch/mips/configs/ip22_defconfig b/arch/mips/configs/ip22_defconfig
index 36de199..73e50fb 100644
--- a/arch/mips/configs/ip22_defconfig
+++ b/arch/mips/configs/ip22_defconfig
@@ -220,7 +220,6 @@ CONFIG_ATA_OVER_ETH=m
 # CONFIG_MISC_DEVICES is not set
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=y
diff --git a/arch/mips/configs/ip27_defconfig b/arch/mips/configs/ip27_defconfig
index 4b16c48..e9feb3d 100644
--- a/arch/mips/configs/ip27_defconfig
+++ b/arch/mips/configs/ip27_defconfig
@@ -106,7 +106,6 @@ CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
 # CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=m
diff --git a/arch/mips/configs/ip32_defconfig b/arch/mips/configs/ip32_defconfig
index 5bea99b..56192da 100644
--- a/arch/mips/configs/ip32_defconfig
+++ b/arch/mips/configs/ip32_defconfig
@@ -54,7 +54,6 @@ CONFIG_BLK_DEV_NBD=m
 CONFIG_SGI_IOC4=y
 CONFIG_RAID_ATTRS=y
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
 CONFIG_BLK_DEV_SR_VENDOR=y
diff --git a/arch/mips/configs/jazz_defconfig b/arch/mips/configs/jazz_defconfig
index 6ae46bc..d07f435 100644
--- a/arch/mips/configs/jazz_defconfig
+++ b/arch/mips/configs/jazz_defconfig
@@ -209,7 +209,6 @@ CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=m
diff --git a/arch/mips/configs/malta_defconfig b/arch/mips/configs/malta_defconfig
index b455d0f..551f3dc 100644
--- a/arch/mips/configs/malta_defconfig
+++ b/arch/mips/configs/malta_defconfig
@@ -282,7 +282,6 @@ CONFIG_BLK_DEV_IT8213=m
 CONFIG_BLK_DEV_TC86C001=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=m
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=m
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
diff --git a/arch/mips/configs/markeins_defconfig b/arch/mips/configs/markeins_defconfig
index 86bf001..1338a90 100644
--- a/arch/mips/configs/markeins_defconfig
+++ b/arch/mips/configs/markeins_defconfig
@@ -136,7 +136,6 @@ CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_SGI_IOC4=m
 CONFIG_SCSI=m
-CONFIG_SCSI_TGT=m
 # CONFIG_SCSI_PROC_FS is not set
 CONFIG_BLK_DEV_SD=m
 CONFIG_CHR_DEV_SG=m
diff --git a/arch/mips/configs/pnx8550-jbs_defconfig b/arch/mips/configs/pnx8550-jbs_defconfig
index 3376bc8..d18eec6 100644
--- a/arch/mips/configs/pnx8550-jbs_defconfig
+++ b/arch/mips/configs/pnx8550-jbs_defconfig
@@ -34,7 +34,6 @@ CONFIG_BLK_DEV_HPT366=y
 CONFIG_BLK_DEV_IT8213=m
 CONFIG_BLK_DEV_TC86C001=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SCAN_ASYNC=y
diff --git a/arch/mips/configs/pnx8550-stb810_defconfig b/arch/mips/configs/pnx8550-stb810_defconfig
index 6514f1b..1aec361 100644
--- a/arch/mips/configs/pnx8550-stb810_defconfig
+++ b/arch/mips/configs/pnx8550-stb810_defconfig
@@ -34,7 +34,6 @@ CONFIG_BLK_DEV_HPT366=y
 CONFIG_BLK_DEV_IT8213=m
 CONFIG_BLK_DEV_TC86C001=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SCAN_ASYNC=y
diff --git a/arch/mips/configs/rm200_defconfig b/arch/mips/configs/rm200_defconfig
index 2b3e476..be49b83 100644
--- a/arch/mips/configs/rm200_defconfig
+++ b/arch/mips/configs/rm200_defconfig
@@ -222,7 +222,6 @@ CONFIG_ATA_OVER_ETH=m
 CONFIG_SGI_IOC4=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=m
diff --git a/arch/mips/configs/tb0226_defconfig b/arch/mips/configs/tb0226_defconfig
index 3d25dd0..7bacd3b 100644
--- a/arch/mips/configs/tb0226_defconfig
+++ b/arch/mips/configs/tb0226_defconfig
@@ -39,7 +39,6 @@ CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_XIP=y
 # CONFIG_MISC_DEVICES is not set
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_SCSI_MULTI_LUN=y
 CONFIG_SCSI_SCAN_ASYNC=y
diff --git a/arch/mips/configs/tb0287_defconfig b/arch/mips/configs/tb0287_defconfig
index be697c9..7ed57d9 100644
--- a/arch/mips/configs/tb0287_defconfig
+++ b/arch/mips/configs/tb0287_defconfig
@@ -44,7 +44,6 @@ CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_XIP=y
 # CONFIG_MISC_DEVICES is not set
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_SCSI_SCAN_ASYNC=y
 # CONFIG_SCSI_LOWLEVEL is not set
diff --git a/arch/powerpc/configs/52xx/motionpro_defconfig b/arch/powerpc/configs/52xx/motionpro_defconfig
index 20d53a1..1a329e9 100644
--- a/arch/powerpc/configs/52xx/motionpro_defconfig
+++ b/arch/powerpc/configs/52xx/motionpro_defconfig
@@ -44,7 +44,6 @@ CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=32768
 CONFIG_EEPROM_LEGACY=y
-CONFIG_SCSI_TGT=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_ATA=y
diff --git a/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig b/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig
index 321fb47..05dbefb 100644
--- a/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig
+++ b/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig
@@ -55,7 +55,6 @@ CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=131072
 CONFIG_IDE=y
-CONFIG_SCSI_TGT=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_ATA=y
diff --git a/arch/powerpc/configs/mpc5200_defconfig b/arch/powerpc/configs/mpc5200_defconfig
index 7376e27..1c69810 100644
--- a/arch/powerpc/configs/mpc5200_defconfig
+++ b/arch/powerpc/configs/mpc5200_defconfig
@@ -53,7 +53,6 @@ CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=32768
 CONFIG_EEPROM_AT24=y
-CONFIG_SCSI_TGT=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_ATA=y
diff --git a/arch/powerpc/configs/ppc6xx_defconfig b/arch/powerpc/configs/ppc6xx_defconfig
index 9d64a68..69d74bf 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -426,7 +426,6 @@ CONFIG_SCSI_LOGGING=y
 CONFIG_SCSI_SCAN_ASYNC=y
 CONFIG_SCSI_SPI_ATTRS=m
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_SCSI_MESH=m
 CONFIG_SCSI_MAC53C94=m
 CONFIG_SCSI_SRP=m
diff --git a/arch/sh/configs/sh2007_defconfig b/arch/sh/configs/sh2007_defconfig
index 0d2f414..73df3e3 100644
--- a/arch/sh/configs/sh2007_defconfig
+++ b/arch/sh/configs/sh2007_defconfig
@@ -52,7 +52,6 @@ CONFIG_CDROM_PKTCDVD=y
 # CONFIG_MISC_DEVICES is not set
 CONFIG_RAID_ATTRS=y
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
 CONFIG_CHR_DEV_SG=y
-- 
1.7.1


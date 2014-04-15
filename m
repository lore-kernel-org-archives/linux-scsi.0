From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/5] tgt: defconfig cleanup
Date: Tue, 15 Apr 2014 12:26:53 +0200
Message-ID: <1397557614-21243-5-git-send-email-hch@lst.de>
References: <1397557614-21243-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:51873 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaDOKYv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Apr 2014 06:24:51 -0400
In-Reply-To: <1397557614-21243-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>

From: Bart Van Assche <bvanassche@acm.org>

Because of the removal of the scsi_tgt kernel module, the kbuild variables
CONFIG_SCSI_TGT, CONFIG_SCSI_SRP_TGT_ATTRS and CONFIG_SCSI_FC_TGT_ATTRS
are obsolete. This patch removes these variables. This patch is the result
of the following command:

find -name '*defconfig' | while read f; do grep -vwE 'CONFIG_SCSI_TGT|CONFIG_SCSI_SRP_TGT_ATTRS|CONFIG_SCSI_FC_TGT_ATTRS|CONFIG_SRP' $f >/tmp/t && mv /tmp/t $f; done

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/arm/configs/msm_defconfig                   |    1 -
 arch/arm/configs/s3c2410_defconfig               |    1 -
 arch/m68k/configs/amiga_defconfig                |    1 -
 arch/m68k/configs/apollo_defconfig               |    1 -
 arch/m68k/configs/atari_defconfig                |    1 -
 arch/m68k/configs/bvme6000_defconfig             |    1 -
 arch/m68k/configs/hp300_defconfig                |    1 -
 arch/m68k/configs/mac_defconfig                  |    1 -
 arch/m68k/configs/multi_defconfig                |    1 -
 arch/m68k/configs/mvme147_defconfig              |    1 -
 arch/m68k/configs/mvme16x_defconfig              |    1 -
 arch/m68k/configs/q40_defconfig                  |    1 -
 arch/m68k/configs/sun3_defconfig                 |    1 -
 arch/m68k/configs/sun3x_defconfig                |    1 -
 arch/mips/configs/db1xxx_defconfig               |    1 -
 arch/mips/configs/decstation_defconfig           |    1 -
 arch/mips/configs/ip22_defconfig                 |    1 -
 arch/mips/configs/ip27_defconfig                 |    1 -
 arch/mips/configs/ip32_defconfig                 |    1 -
 arch/mips/configs/jazz_defconfig                 |    1 -
 arch/mips/configs/loongson3_defconfig            |    1 -
 arch/mips/configs/malta_defconfig                |    1 -
 arch/mips/configs/malta_kvm_defconfig            |    1 -
 arch/mips/configs/malta_kvm_guest_defconfig      |    1 -
 arch/mips/configs/markeins_defconfig             |    1 -
 arch/mips/configs/nlm_xlp_defconfig              |    3 ---
 arch/mips/configs/nlm_xlr_defconfig              |    3 ---
 arch/mips/configs/rm200_defconfig                |    1 -
 arch/mips/configs/tb0226_defconfig               |    1 -
 arch/mips/configs/tb0287_defconfig               |    1 -
 arch/powerpc/configs/52xx/motionpro_defconfig    |    1 -
 arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig |    1 -
 arch/powerpc/configs/mpc5200_defconfig           |    1 -
 arch/powerpc/configs/ppc6xx_defconfig            |    2 --
 arch/s390/configs/default_defconfig              |    2 --
 arch/s390/configs/gcov_defconfig                 |    2 --
 arch/s390/configs/performance_defconfig          |    2 --
 arch/sh/configs/sh2007_defconfig                 |    1 -
 arch/tile/configs/tilegx_defconfig               |    1 -
 arch/tile/configs/tilepro_defconfig              |    1 -
 40 files changed, 48 deletions(-)

diff --git a/arch/arm/configs/msm_defconfig b/arch/arm/configs/msm_defconfig
index c5858b9..faab342 100644
--- a/arch/arm/configs/msm_defconfig
+++ b/arch/arm/configs/msm_defconfig
@@ -52,7 +52,6 @@ CONFIG_RFKILL=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_CHR_DEV_SCH=y
diff --git a/arch/arm/configs/s3c2410_defconfig b/arch/arm/configs/s3c2410_defconfig
index 193448f..7c3a0b7 100644
--- a/arch/arm/configs/s3c2410_defconfig
+++ b/arch/arm/configs/s3c2410_defconfig
@@ -225,7 +225,6 @@ CONFIG_BLK_DEV_IDECD=y
 CONFIG_BLK_DEV_IDETAPE=m
 CONFIG_BLK_DEV_PLATFORM=y
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=m
diff --git a/arch/m68k/configs/amiga_defconfig b/arch/m68k/configs/amiga_defconfig
index 96da496..0adad4d 100644
--- a/arch/m68k/configs/amiga_defconfig
+++ b/arch/m68k/configs/amiga_defconfig
@@ -255,7 +255,6 @@ CONFIG_BLK_DEV_GAYLE=y
 CONFIG_BLK_DEV_BUDDHA=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
diff --git a/arch/m68k/configs/apollo_defconfig b/arch/m68k/configs/apollo_defconfig
index 1b8739f..d46f5a8 100644
--- a/arch/m68k/configs/apollo_defconfig
+++ b/arch/m68k/configs/apollo_defconfig
@@ -242,7 +242,6 @@ CONFIG_ATA_OVER_ETH=m
 CONFIG_DUMMY_IRQ=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
diff --git a/arch/m68k/configs/atari_defconfig b/arch/m68k/configs/atari_defconfig
index 6ea4e91..9c073a4 100644
--- a/arch/m68k/configs/atari_defconfig
+++ b/arch/m68k/configs/atari_defconfig
@@ -249,7 +249,6 @@ CONFIG_BLK_DEV_IDECD=y
 CONFIG_BLK_DEV_FALCON_IDE=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
diff --git a/arch/m68k/configs/bvme6000_defconfig b/arch/m68k/configs/bvme6000_defconfig
index e5a1273..edfad1a 100644
--- a/arch/m68k/configs/bvme6000_defconfig
+++ b/arch/m68k/configs/bvme6000_defconfig
@@ -240,7 +240,6 @@ CONFIG_ATA_OVER_ETH=m
 CONFIG_DUMMY_IRQ=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
diff --git a/arch/m68k/configs/hp300_defconfig b/arch/m68k/configs/hp300_defconfig
index 8936d7f..f0bbc9c 100644
--- a/arch/m68k/configs/hp300_defconfig
+++ b/arch/m68k/configs/hp300_defconfig
@@ -242,7 +242,6 @@ CONFIG_ATA_OVER_ETH=m
 CONFIG_DUMMY_IRQ=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
diff --git a/arch/m68k/configs/mac_defconfig b/arch/m68k/configs/mac_defconfig
index be5342c..6f42b1c 100644
--- a/arch/m68k/configs/mac_defconfig
+++ b/arch/m68k/configs/mac_defconfig
@@ -249,7 +249,6 @@ CONFIG_BLK_DEV_IDECD=y
 CONFIG_BLK_DEV_MAC_IDE=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
diff --git a/arch/m68k/configs/multi_defconfig b/arch/m68k/configs/multi_defconfig
index f27194a..454e6e2 100644
--- a/arch/m68k/configs/multi_defconfig
+++ b/arch/m68k/configs/multi_defconfig
@@ -271,7 +271,6 @@ CONFIG_BLK_DEV_MAC_IDE=y
 CONFIG_BLK_DEV_Q40IDE=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
diff --git a/arch/m68k/configs/mvme147_defconfig b/arch/m68k/configs/mvme147_defconfig
index c388760..897170f 100644
--- a/arch/m68k/configs/mvme147_defconfig
+++ b/arch/m68k/configs/mvme147_defconfig
@@ -239,7 +239,6 @@ CONFIG_ATA_OVER_ETH=m
 CONFIG_DUMMY_IRQ=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
diff --git a/arch/m68k/configs/mvme16x_defconfig b/arch/m68k/configs/mvme16x_defconfig
index f7ff784..5177bbf 100644
--- a/arch/m68k/configs/mvme16x_defconfig
+++ b/arch/m68k/configs/mvme16x_defconfig
@@ -240,7 +240,6 @@ CONFIG_ATA_OVER_ETH=m
 CONFIG_DUMMY_IRQ=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
diff --git a/arch/m68k/configs/q40_defconfig b/arch/m68k/configs/q40_defconfig
index f0c72ab..4fd7cfe 100644
--- a/arch/m68k/configs/q40_defconfig
+++ b/arch/m68k/configs/q40_defconfig
@@ -247,7 +247,6 @@ CONFIG_BLK_DEV_IDECD=y
 CONFIG_BLK_DEV_Q40IDE=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
diff --git a/arch/m68k/configs/sun3_defconfig b/arch/m68k/configs/sun3_defconfig
index 7bca0f4..bff3f16 100644
--- a/arch/m68k/configs/sun3_defconfig
+++ b/arch/m68k/configs/sun3_defconfig
@@ -237,7 +237,6 @@ CONFIG_ATA_OVER_ETH=m
 CONFIG_DUMMY_IRQ=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
diff --git a/arch/m68k/configs/sun3x_defconfig b/arch/m68k/configs/sun3x_defconfig
index 317f3e1..29aaef7 100644
--- a/arch/m68k/configs/sun3x_defconfig
+++ b/arch/m68k/configs/sun3x_defconfig
@@ -237,7 +237,6 @@ CONFIG_ATA_OVER_ETH=m
 CONFIG_DUMMY_IRQ=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
diff --git a/arch/mips/configs/db1xxx_defconfig b/arch/mips/configs/db1xxx_defconfig
index c99b6ee..e833b46 100644
--- a/arch/mips/configs/db1xxx_defconfig
+++ b/arch/mips/configs/db1xxx_defconfig
@@ -115,7 +115,6 @@ CONFIG_MTD_NAND_AU1550=y
 CONFIG_MTD_NAND_PLATFORM=y
 CONFIG_EEPROM_AT24=y
 CONFIG_EEPROM_AT25=y
-CONFIG_SCSI_TGT=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_MULTI_LUN=y
diff --git a/arch/mips/configs/decstation_defconfig b/arch/mips/configs/decstation_defconfig
index 87d0340..ebc011c 100644
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
index 936ec5a..57ed466 100644
--- a/arch/mips/configs/ip22_defconfig
+++ b/arch/mips/configs/ip22_defconfig
@@ -219,7 +219,6 @@ CONFIG_ATA_OVER_ETH=m
 # CONFIG_MISC_DEVICES is not set
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=y
diff --git a/arch/mips/configs/ip27_defconfig b/arch/mips/configs/ip27_defconfig
index 0e36abc..cc07560 100644
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
index 7bbd521..70ffe9b 100644
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
index 0315ee3..2575302 100644
--- a/arch/mips/configs/jazz_defconfig
+++ b/arch/mips/configs/jazz_defconfig
@@ -208,7 +208,6 @@ CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=m
diff --git a/arch/mips/configs/loongson3_defconfig b/arch/mips/configs/loongson3_defconfig
index ea1761f..fca91a8 100644
--- a/arch/mips/configs/loongson3_defconfig
+++ b/arch/mips/configs/loongson3_defconfig
@@ -120,7 +120,6 @@ CONFIG_BLK_DEV_CRYPTOLOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=8192
 CONFIG_RAID_ATTRS=m
-CONFIG_SCSI_TGT=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
 CONFIG_CHR_DEV_SG=y
diff --git a/arch/mips/configs/malta_defconfig b/arch/mips/configs/malta_defconfig
index b745b6a..e18741e 100644
--- a/arch/mips/configs/malta_defconfig
+++ b/arch/mips/configs/malta_defconfig
@@ -253,7 +253,6 @@ CONFIG_BLK_DEV_IT8213=m
 CONFIG_BLK_DEV_TC86C001=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=m
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=m
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
diff --git a/arch/mips/configs/malta_kvm_defconfig b/arch/mips/configs/malta_kvm_defconfig
index 4f7d952..cf0e01f 100644
--- a/arch/mips/configs/malta_kvm_defconfig
+++ b/arch/mips/configs/malta_kvm_defconfig
@@ -254,7 +254,6 @@ CONFIG_BLK_DEV_IT8213=m
 CONFIG_BLK_DEV_TC86C001=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=m
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=m
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
diff --git a/arch/mips/configs/malta_kvm_guest_defconfig b/arch/mips/configs/malta_kvm_guest_defconfig
index e36681c..edd9ec9 100644
--- a/arch/mips/configs/malta_kvm_guest_defconfig
+++ b/arch/mips/configs/malta_kvm_guest_defconfig
@@ -254,7 +254,6 @@ CONFIG_BLK_DEV_IT8213=m
 CONFIG_BLK_DEV_TC86C001=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=m
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=m
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
diff --git a/arch/mips/configs/markeins_defconfig b/arch/mips/configs/markeins_defconfig
index 4c2c0c4..0f08e46 100644
--- a/arch/mips/configs/markeins_defconfig
+++ b/arch/mips/configs/markeins_defconfig
@@ -134,7 +134,6 @@ CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_CRYPTOLOOP=m
 CONFIG_SGI_IOC4=m
 CONFIG_SCSI=m
-CONFIG_SCSI_TGT=m
 # CONFIG_SCSI_PROC_FS is not set
 CONFIG_BLK_DEV_SD=m
 CONFIG_CHR_DEV_SG=m
diff --git a/arch/mips/configs/nlm_xlp_defconfig b/arch/mips/configs/nlm_xlp_defconfig
index 5468b1c..2f660e9 100644
--- a/arch/mips/configs/nlm_xlp_defconfig
+++ b/arch/mips/configs/nlm_xlp_defconfig
@@ -334,7 +334,6 @@ CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=65536
 CONFIG_CDROM_PKTCDVD=y
 CONFIG_RAID_ATTRS=m
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
@@ -346,10 +345,8 @@ CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
 CONFIG_SCSI_SCAN_ASYNC=y
 CONFIG_SCSI_SPI_ATTRS=m
-CONFIG_SCSI_FC_TGT_ATTRS=y
 CONFIG_SCSI_SAS_LIBSAS=m
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_ISCSI_TCP=m
 CONFIG_LIBFCOE=m
 CONFIG_SCSI_DEBUG=m
diff --git a/arch/mips/configs/nlm_xlr_defconfig b/arch/mips/configs/nlm_xlr_defconfig
index 44b4734..c6f8465 100644
--- a/arch/mips/configs/nlm_xlr_defconfig
+++ b/arch/mips/configs/nlm_xlr_defconfig
@@ -311,7 +311,6 @@ CONFIG_CDROM_PKTCDVD=y
 CONFIG_MISC_DEVICES=y
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
@@ -323,10 +322,8 @@ CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
 CONFIG_SCSI_SCAN_ASYNC=y
 CONFIG_SCSI_SPI_ATTRS=m
-CONFIG_SCSI_FC_TGT_ATTRS=y
 CONFIG_SCSI_SAS_LIBSAS=m
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_ISCSI_TCP=m
 CONFIG_LIBFCOE=m
 CONFIG_SCSI_DEBUG=m
diff --git a/arch/mips/configs/rm200_defconfig b/arch/mips/configs/rm200_defconfig
index 59d9d2f..aadf750 100644
--- a/arch/mips/configs/rm200_defconfig
+++ b/arch/mips/configs/rm200_defconfig
@@ -221,7 +221,6 @@ CONFIG_ATA_OVER_ETH=m
 CONFIG_SGI_IOC4=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=m
diff --git a/arch/mips/configs/tb0226_defconfig b/arch/mips/configs/tb0226_defconfig
index 81bfa1d..bf0f043 100644
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
index c415c4f..a967289 100644
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
index c05310a..c936fab 100644
--- a/arch/powerpc/configs/52xx/motionpro_defconfig
+++ b/arch/powerpc/configs/52xx/motionpro_defconfig
@@ -43,7 +43,6 @@ CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=32768
 CONFIG_MISC_DEVICES=y
 CONFIG_EEPROM_LEGACY=y
-CONFIG_SCSI_TGT=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_ATA=y
diff --git a/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig b/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig
index bcbe747..9b192bb 100644
--- a/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig
+++ b/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig
@@ -54,7 +54,6 @@ CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=131072
 CONFIG_IDE=y
-CONFIG_SCSI_TGT=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_ATA=y
diff --git a/arch/powerpc/configs/mpc5200_defconfig b/arch/powerpc/configs/mpc5200_defconfig
index 8b682d1c..0880a54 100644
--- a/arch/powerpc/configs/mpc5200_defconfig
+++ b/arch/powerpc/configs/mpc5200_defconfig
@@ -47,7 +47,6 @@ CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=32768
 CONFIG_EEPROM_AT24=y
-CONFIG_SCSI_TGT=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_ATA=y
diff --git a/arch/powerpc/configs/ppc6xx_defconfig b/arch/powerpc/configs/ppc6xx_defconfig
index 175a8b9..32d9dd3 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -425,10 +425,8 @@ CONFIG_SCSI_LOGGING=y
 CONFIG_SCSI_SCAN_ASYNC=y
 CONFIG_SCSI_SPI_ATTRS=m
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_SCSI_MESH=m
 CONFIG_SCSI_MAC53C94=m
-CONFIG_SCSI_SRP=m
 CONFIG_SCSI_LOWLEVEL_PCMCIA=y
 CONFIG_SCSI_DH=y
 CONFIG_SCSI_DH_RDAC=m
diff --git a/arch/s390/configs/default_defconfig b/arch/s390/configs/default_defconfig
index 8df022c..3c9c3d3 100644
--- a/arch/s390/configs/default_defconfig
+++ b/arch/s390/configs/default_defconfig
@@ -366,7 +366,6 @@ CONFIG_VIRTIO_BLK=y
 CONFIG_ENCLOSURE_SERVICES=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
@@ -380,7 +379,6 @@ CONFIG_SCSI_LOGGING=y
 CONFIG_SCSI_SPI_ATTRS=m
 CONFIG_SCSI_SAS_LIBSAS=m
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_ISCSI_TCP=m
 CONFIG_LIBFCOE=m
 CONFIG_SCSI_DEBUG=m
diff --git a/arch/s390/configs/gcov_defconfig b/arch/s390/configs/gcov_defconfig
index c81a74e..7f3adf2b 100644
--- a/arch/s390/configs/gcov_defconfig
+++ b/arch/s390/configs/gcov_defconfig
@@ -363,7 +363,6 @@ CONFIG_VIRTIO_BLK=y
 CONFIG_ENCLOSURE_SERVICES=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
@@ -377,7 +376,6 @@ CONFIG_SCSI_LOGGING=y
 CONFIG_SCSI_SPI_ATTRS=m
 CONFIG_SCSI_SAS_LIBSAS=m
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_ISCSI_TCP=m
 CONFIG_LIBFCOE=m
 CONFIG_SCSI_DEBUG=m
diff --git a/arch/s390/configs/performance_defconfig b/arch/s390/configs/performance_defconfig
index b5ba8fe..191a077 100644
--- a/arch/s390/configs/performance_defconfig
+++ b/arch/s390/configs/performance_defconfig
@@ -361,7 +361,6 @@ CONFIG_VIRTIO_BLK=y
 CONFIG_ENCLOSURE_SERVICES=m
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
@@ -375,7 +374,6 @@ CONFIG_SCSI_LOGGING=y
 CONFIG_SCSI_SPI_ATTRS=m
 CONFIG_SCSI_SAS_LIBSAS=m
 CONFIG_SCSI_SRP_ATTRS=m
-CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_ISCSI_TCP=m
 CONFIG_LIBFCOE=m
 CONFIG_SCSI_DEBUG=m
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
diff --git a/arch/tile/configs/tilegx_defconfig b/arch/tile/configs/tilegx_defconfig
index 730e40d..91de7dd 100644
--- a/arch/tile/configs/tilegx_defconfig
+++ b/arch/tile/configs/tilegx_defconfig
@@ -170,7 +170,6 @@ CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=16384
 CONFIG_ATA_OVER_ETH=m
 CONFIG_RAID_ATTRS=m
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
diff --git a/arch/tile/configs/tilepro_defconfig b/arch/tile/configs/tilepro_defconfig
index 80fc32e..c7702b7a 100644
--- a/arch/tile/configs/tilepro_defconfig
+++ b/arch/tile/configs/tilepro_defconfig
@@ -301,7 +301,6 @@ CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=16384
 CONFIG_ATA_OVER_ETH=m
 CONFIG_RAID_ATTRS=m
-CONFIG_SCSI_TGT=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
-- 
1.7.10.4


From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] PATCH 2.5: kconfig sychronise banners (2_16)
Date: Wed, 07 Aug 2002 14:06:07 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020807043056.428DF4B4C@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: geert@linux-m68k.org, linux-scsi@vger.kernel.org

From:  Greg Banks <gnb@alphalink.com.au>

(Included in 2.5)
  G'day,
  
  
  2/5 definitions of CONFIG_BLK_DEV_SR have trivially different banners.
  

--- trivial-2.4.20-pre1/arch/m68k/config.in.orig	2002-08-07 10:57:32.000000000 +1000
+++ trivial-2.4.20-pre1/arch/m68k/config.in	2002-08-07 10:57:32.000000000 +1000
@@ -205,7 +205,7 @@
    if [ "$CONFIG_CHR_DEV_ST" != "n" ]; then
       int  'Maximum number of SCSI tapes that can be loaded as modules' CONFIG_ST_EXTRA_DEVS 2
    fi
-   dep_tristate '  SCSI CD-ROM support' CONFIG_BLK_DEV_SR $CONFIG_SCSI
+   dep_tristate '  SCSI CDROM support' CONFIG_BLK_DEV_SR $CONFIG_SCSI
    if [ "$CONFIG_BLK_DEV_SR" != "n" ]; then
       bool '    Enable vendor-specific extensions (for SCSI CDROM)' CONFIG_BLK_DEV_SR_VENDOR
       int  'Maximum number of CDROM devices that can be loaded as modules' CONFIG_SR_EXTRA_DEVS 2
--- trivial-2.4.20-pre1/drivers/scsi/Config.in.orig	2002-08-07 10:57:32.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/scsi/Config.in	2002-08-07 10:57:32.000000000 +1000
@@ -10,7 +10,7 @@
 
 dep_tristate '  SCSI OnStream SC-x0 tape support' CONFIG_CHR_DEV_OSST $CONFIG_SCSI
 
-dep_tristate '  SCSI CD-ROM support' CONFIG_BLK_DEV_SR $CONFIG_SCSI
+dep_tristate '  SCSI CDROM support' CONFIG_BLK_DEV_SR $CONFIG_SCSI
 
 if [ "$CONFIG_BLK_DEV_SR" != "n" ]; then
    bool '    Enable vendor-specific extensions (for SCSI CDROM)' CONFIG_BLK_DEV_SR_VENDOR
-- 
  Don't blame me: the Monkey is driving

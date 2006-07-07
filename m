From: akpm@osdl.org
Subject: [patch 09/19] aic7*: cleanup MODULE_PARM_DESC strings
Date: Fri, 07 Jul 2006 00:01:01 -0700
Message-ID: <200607070701.k67711sS030566@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:53442 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751230AbWGGHBH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jul 2006 03:01:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, rdunlap@xenotime.net

From: Randy Dunlap <rdunlap@xenotime.net>

Modify beginning string to be more readable.  Remove one trailing newline.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/aic7xxx/aic79xx_osm.c |    4 ++--
 drivers/scsi/aic7xxx/aic7xxx_osm.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_osm.c~aic7-cleanup-module_parm_desc-strings drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c~aic7-cleanup-module_parm_desc-strings
+++ a/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -340,7 +340,7 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(AIC79XX_DRIVER_VERSION);
 module_param(aic79xx, charp, 0444);
 MODULE_PARM_DESC(aic79xx,
-"period delimited, options string.\n"
+"period-delimited options string:\n"
 "	verbose			Enable verbose/diagnostic logging\n"
 "	allow_memio		Allow device registers to be memory mapped\n"
 "	debug			Bitmask of debug values to enable\n"
@@ -366,7 +366,7 @@ MODULE_PARM_DESC(aic79xx,
 "		Shorten the selection timeout to 128ms\n"
 "\n"
 "	options aic79xx 'aic79xx=verbose.tag_info:{{}.{}.{..10}}.seltime:1'\n"
-"\n");
+);
 
 static void ahd_linux_handle_scsi_status(struct ahd_softc *,
 					 struct scsi_device *,
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.c~aic7-cleanup-module_parm_desc-strings drivers/scsi/aic7xxx/aic7xxx_osm.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c~aic7-cleanup-module_parm_desc-strings
+++ a/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -341,7 +341,7 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(AIC7XXX_DRIVER_VERSION);
 module_param(aic7xxx, charp, 0444);
 MODULE_PARM_DESC(aic7xxx,
-"period delimited, options string.\n"
+"period-delimited options string:\n"
 "	verbose			Enable verbose/diagnostic logging\n"
 "	allow_memio		Allow device registers to be memory mapped\n"
 "	debug			Bitmask of debug values to enable\n"
_

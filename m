From: akpm@osdl.org
Subject: [patch 19/25] aic7*: cleanup MODULE_PARM_DESC strings
Date: Thu, 01 Jun 2006 20:42:44 -0700
Message-ID: <200606020338.k523cQ4g029261@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:17847 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751223AbWFBDi3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2006 23:38:29 -0400
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
--- devel/drivers/scsi/aic7xxx/aic79xx_osm.c~aic7-cleanup-module_parm_desc-strings	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic79xx_osm.c	2006-06-01 20:41:51.000000000 -0700
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
--- devel/drivers/scsi/aic7xxx/aic7xxx_osm.c~aic7-cleanup-module_parm_desc-strings	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic7xxx_osm.c	2006-06-01 20:41:51.000000000 -0700
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

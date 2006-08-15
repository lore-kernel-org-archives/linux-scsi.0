From: akpm@osdl.org
Subject: [patch 08/24] aic7*: cleanup MODULE_PARM_DESC strings
Date: Mon, 14 Aug 2006 23:09:23 -0700
Message-ID: <200608150609.k7F69N0A013220@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:51349 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965179AbWHOGJ2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Aug 2006 02:09:28 -0400
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
@@ -321,7 +321,7 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(AIC79XX_DRIVER_VERSION);
 module_param(aic79xx, charp, 0444);
 MODULE_PARM_DESC(aic79xx,
-"period delimited, options string.\n"
+"period-delimited options string:\n"
 "	verbose			Enable verbose/diagnostic logging\n"
 "	allow_memio		Allow device registers to be memory mapped\n"
 "	debug			Bitmask of debug values to enable\n"
@@ -346,7 +346,7 @@ MODULE_PARM_DESC(aic79xx,
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

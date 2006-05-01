From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: [PATCH] aic7*: cleanup MODULE_PARM_DESC strings
Date: Sun, 30 Apr 2006 19:25:44 -0700
Message-ID: <20060430192544.f48da359.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:29878 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1750764AbWEACXT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Apr 2006 22:23:19 -0400
Received: from midway.site ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Sun, 30 Apr 2006 19:23:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>, akpm <akpm@osdl.org>

From: Randy Dunlap <rdunlap@xenotime.net>

Modify beginning string to be more readable.
Remove one trailing newline.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c |    4 ++--
 drivers/scsi/aic7xxx/aic7xxx_osm.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- linux-2617-rc3.orig/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ linux-2617-rc3/drivers/scsi/aic7xxx/aic79xx_osm.c
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
--- linux-2617-rc3.orig/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ linux-2617-rc3/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -341,7 +341,7 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(AIC7XXX_DRIVER_VERSION);
 module_param(aic7xxx, charp, 0444);
 MODULE_PARM_DESC(aic7xxx,
-"period delimited, options string.\n"
+"period-delimited options string:\n"
 "	verbose			Enable verbose/diagnostic logging\n"
 "	allow_memio		Allow device registers to be memory mapped\n"
 "	debug			Bitmask of debug values to enable\n"


---

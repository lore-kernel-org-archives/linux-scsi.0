From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 2/4] aic7xxx: Update Maintainer information
Date: Fri, 19 Oct 2007 10:32:29 +0200
Message-ID: <20071019083229.6AF9718C61E@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47020 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966289AbXJSIcM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Oct 2007 04:32:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org


Might as well take the blame officially.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 MAINTAINERS                        |    6 ++++++
 drivers/scsi/aic7xxx/aic79xx_osm.c |    4 ++--
 drivers/scsi/aic7xxx/aic7xxx_osm.c |    4 ++--
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 10deabe..75fd297 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -325,6 +325,12 @@ M:	Juergen Fischer <fischer@norbit.de>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 
+AIC7XXX / AIC79XX SCSI DRIVER
+P:	Hannes Reinecke
+M:	hare@suse.de
+L:	linux-scsi@vger.kernel.org
+S:	Maintained
+
 ALCATEL SPEEDTOUCH USB DRIVER
 P:	Duncan Sands
 M:	duncan.sands@free.fr
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 42c0f14..2d02040 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -315,8 +315,8 @@ uint32_t aic79xx_slowcrc;
  */
 static char *aic79xx = NULL;
 
-MODULE_AUTHOR("Maintainer: Justin T. Gibbs <gibbs@scsiguy.com>");
-MODULE_DESCRIPTION("Adaptec Aic790X U320 SCSI Host Bus Adapter driver");
+MODULE_AUTHOR("Maintainer: Hannes Reinecke <hare@suse.de>");
+MODULE_DESCRIPTION("Adaptec AIC790X U320 SCSI Host Bus Adapter driver");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(AIC79XX_DRIVER_VERSION);
 module_param(aic79xx, charp, 0444);
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 7770bef..390b0fc 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -335,8 +335,8 @@ static uint32_t aic7xxx_periodic_otag;
  */
 static char *aic7xxx = NULL;
 
-MODULE_AUTHOR("Maintainer: Justin T. Gibbs <gibbs@scsiguy.com>");
-MODULE_DESCRIPTION("Adaptec Aic77XX/78XX SCSI Host Bus Adapter driver");
+MODULE_AUTHOR("Maintainer: Hannes Reinecke <hare@suse.de>");
+MODULE_DESCRIPTION("Adaptec AIC77XX/78XX SCSI Host Bus Adapter driver");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(AIC7XXX_DRIVER_VERSION);
 module_param(aic7xxx, charp, 0444);
-- 
1.5.2.4


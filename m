From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [2/3] add MODULE_VERSION to drivers/scsi
Date: Wed, 21 Jul 2004 17:02:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040721220231.GC16608@lists.us.dell.com>
References: <20040721220111.GA16608@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linux.us.dell.com ([143.166.224.162]:51033 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S266757AbUGUWE1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jul 2004 18:04:27 -0400
Content-Disposition: inline
In-Reply-To: <20040721220111.GA16608@lists.us.dell.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jgarzik@pobox.com

You can import this changeset into BK by piping this whole message to
'| bk receive [path to repository]' or apply the patch as usual.

===================================================================


ChangeSet@1.1842.1.2, 2004-07-19 18:00:35-04:00, Matt_Domsch@dell.com
  Set MODULE_VERSION for drivers/scsi
  
  for Adaptec SCSI, megaraid qla1280, qla2x00


 aacraid/linit.c       |    1 +
 aic7xxx/aic79xx_osm.c |    5 +----
 aic7xxx/aic7xxx_osm.c |    5 +----
 aic7xxx_old.c         |    1 +
 megaraid.c            |    3 +++
 qla1280.c             |    1 +
 qla2xxx/ql2100.c      |    1 +
 qla2xxx/ql2200.c      |    1 +
 qla2xxx/ql2300.c      |    1 +
 qla2xxx/ql2322.c      |    1 +
 qla2xxx/ql6312.c      |    1 +
 qla2xxx/ql6322.c      |    1 +
 qla2xxx/qla_os.c      |    1 +
 13 files changed, 15 insertions, 8 deletions


diff -Nru a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c	2004-07-21 16:57:31 -05:00
+++ b/drivers/scsi/aacraid/linit.c	2004-07-21 16:57:31 -05:00
@@ -62,6 +62,7 @@
 		   "Adaptec Advanced Raid Products, "
 		   "and HP NetRAID-4M SCSI driver");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(AAC_DRIVER_VERSION);
 
 
 int nondasd = -1;
diff -Nru a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c	2004-07-21 16:57:31 -05:00
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c	2004-07-21 16:57:31 -05:00
@@ -415,7 +415,6 @@
 /*
  * Module information and settable options.
  */
-#ifdef MODULE
 static char *aic79xx = NULL;
 /*
  * Just in case someone uses commas to separate items on the insmod
@@ -426,9 +425,8 @@
 
 MODULE_AUTHOR("Maintainer: Justin T. Gibbs <gibbs@scsiguy.com>");
 MODULE_DESCRIPTION("Adaptec Aic790X U320 SCSI Host Bus Adapter driver");
-#ifdef MODULE_LICENSE
 MODULE_LICENSE("Dual BSD/GPL");
-#endif
+MODULE_VERSION(AIC79XX_DRIVER_VERSION);
 MODULE_PARM(aic79xx, "s");
 MODULE_PARM_DESC(aic79xx,
 "period delimited, options string.\n"
@@ -463,7 +461,6 @@
 "		Change Read Streaming for Controller's 2 and 3\n"
 "\n"
 "	options aic79xx 'aic79xx=rd_strm:{..0xFFF0.0xC0F0}'");
-#endif
 
 static void ahd_linux_handle_scsi_status(struct ahd_softc *,
 					 struct ahd_linux_device *,
diff -Nru a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c	2004-07-21 16:57:31 -05:00
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c	2004-07-21 16:57:31 -05:00
@@ -436,7 +436,6 @@
 /*
  * Module information and settable options.
  */
-#ifdef MODULE
 static char *aic7xxx = NULL;
 /*
  * Just in case someone uses commas to separate items on the insmod
@@ -447,9 +446,8 @@
 
 MODULE_AUTHOR("Maintainer: Justin T. Gibbs <gibbs@scsiguy.com>");
 MODULE_DESCRIPTION("Adaptec Aic77XX/78XX SCSI Host Bus Adapter driver");
-#ifdef MODULE_LICENSE
 MODULE_LICENSE("Dual BSD/GPL");
-#endif
+MODULE_VERSION(AIC7XXX_DRIVER_VERSION);
 MODULE_PARM(aic7xxx, "s");
 MODULE_PARM_DESC(aic7xxx,
 "period delimited, options string.\n"
@@ -479,7 +477,6 @@
 "\n"
 "	options aic7xxx 'aic7xxx=probe_eisa_vl.tag_info:{{}.{.10}}.seltime:1'\n"
 );
-#endif
 
 static void ahc_linux_handle_scsi_status(struct ahc_softc *,
 					 struct ahc_linux_device *,
diff -Nru a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
--- a/drivers/scsi/aic7xxx_old.c	2004-07-21 16:57:31 -05:00
+++ b/drivers/scsi/aic7xxx_old.c	2004-07-21 16:57:31 -05:00
@@ -11139,6 +11139,7 @@
 #include "aic7xxx_old/aic7xxx_proc.c"
 
 MODULE_LICENSE("Dual BSD/GPL");
+MODULE_VERSION(AIC7XXX_H_VERSION);
 
 
 static Scsi_Host_Template driver_template = {
diff -Nru a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c	2004-07-21 16:57:31 -05:00
+++ b/drivers/scsi/megaraid.c	2004-07-21 16:57:31 -05:00
@@ -53,9 +53,12 @@
 
 #include "megaraid.h"
 
+#define MEGARAID_MODULE_VERSION "2.00.3"
+
 MODULE_AUTHOR ("LSI Logic Corporation");
 MODULE_DESCRIPTION ("LSI Logic MegaRAID driver");
 MODULE_LICENSE ("GPL");
+MODULE_VERSION(MEGARAID_MODULE_VERSION);
 
 static unsigned int max_cmd_per_lun = DEF_CMD_PER_LUN;
 MODULE_PARM(max_cmd_per_lun, "i");
diff -Nru a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c	2004-07-21 16:57:31 -05:00
+++ b/drivers/scsi/qla1280.c	2004-07-21 16:57:31 -05:00
@@ -4936,6 +4936,7 @@
 MODULE_AUTHOR("Qlogic & Jes Sorensen");
 MODULE_DESCRIPTION("Qlogic ISP SCSI (qla1x80/qla1x160) driver");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(QLA1280_VERSION);
 
 /*
  * Overrides for Emacs so that we almost follow Linus's tabbing style.
diff -Nru a/drivers/scsi/qla2xxx/ql2100.c b/drivers/scsi/qla2xxx/ql2100.c
--- a/drivers/scsi/qla2xxx/ql2100.c	2004-07-21 16:57:31 -05:00
+++ b/drivers/scsi/qla2xxx/ql2100.c	2004-07-21 16:57:31 -05:00
@@ -89,3 +89,4 @@
 MODULE_AUTHOR("QLogic Corporation");
 MODULE_DESCRIPTION("QLogic ISP21xx FC-SCSI Host Bus Adapter driver");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(QLA2XXX_VERSION);
diff -Nru a/drivers/scsi/qla2xxx/ql2200.c b/drivers/scsi/qla2xxx/ql2200.c
--- a/drivers/scsi/qla2xxx/ql2200.c	2004-07-21 16:57:31 -05:00
+++ b/drivers/scsi/qla2xxx/ql2200.c	2004-07-21 16:57:31 -05:00
@@ -89,3 +89,4 @@
 MODULE_AUTHOR("QLogic Corporation");
 MODULE_DESCRIPTION("QLogic ISP22xx FC-SCSI Host Bus Adapter driver");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(QLA2XXX_VERSION);
diff -Nru a/drivers/scsi/qla2xxx/ql2300.c b/drivers/scsi/qla2xxx/ql2300.c
--- a/drivers/scsi/qla2xxx/ql2300.c	2004-07-21 16:57:31 -05:00
+++ b/drivers/scsi/qla2xxx/ql2300.c	2004-07-21 16:57:31 -05:00
@@ -100,3 +100,4 @@
 MODULE_AUTHOR("QLogic Corporation");
 MODULE_DESCRIPTION("QLogic ISP2300 FC-SCSI Host Bus Adapter driver");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(QLA2XXX_VERSION);
diff -Nru a/drivers/scsi/qla2xxx/ql2322.c b/drivers/scsi/qla2xxx/ql2322.c
--- a/drivers/scsi/qla2xxx/ql2322.c	2004-07-21 16:57:31 -05:00
+++ b/drivers/scsi/qla2xxx/ql2322.c	2004-07-21 16:57:31 -05:00
@@ -105,3 +105,4 @@
 MODULE_AUTHOR("QLogic Corporation");
 MODULE_DESCRIPTION("QLogic ISP2322 FC-SCSI Host Bus Adapter driver");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(QLA2XXX_VERSION);
diff -Nru a/drivers/scsi/qla2xxx/ql6312.c b/drivers/scsi/qla2xxx/ql6312.c
--- a/drivers/scsi/qla2xxx/ql6312.c	2004-07-21 16:57:31 -05:00
+++ b/drivers/scsi/qla2xxx/ql6312.c	2004-07-21 16:57:31 -05:00
@@ -87,3 +87,4 @@
 MODULE_AUTHOR("QLogic Corporation");
 MODULE_DESCRIPTION("QLogic ISP6312 FC-SCSI Host Bus Adapter driver");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(QLA2XXX_VERSION);
diff -Nru a/drivers/scsi/qla2xxx/ql6322.c b/drivers/scsi/qla2xxx/ql6322.c
--- a/drivers/scsi/qla2xxx/ql6322.c	2004-07-21 16:57:31 -05:00
+++ b/drivers/scsi/qla2xxx/ql6322.c	2004-07-21 16:57:31 -05:00
@@ -105,3 +105,4 @@
 MODULE_AUTHOR("QLogic Corporation");
 MODULE_DESCRIPTION("QLogic ISP6322 FC-SCSI Host Bus Adapter driver");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(QLA2XXX_VERSION);
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	2004-07-21 16:57:31 -05:00
+++ b/drivers/scsi/qla2xxx/qla_os.c	2004-07-21 16:57:31 -05:00
@@ -4517,3 +4517,4 @@
 MODULE_AUTHOR("QLogic Corporation");
 MODULE_DESCRIPTION("QLogic Fibre Channel HBA Driver");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(QLA2XXX_VERSION);

===================================================================


This BitKeeper patch contains the following changesets:
1.1842.1.2
## Wrapped with gzip_uu ##


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
 

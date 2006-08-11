From: Dave Jones <davej@redhat.com>
Subject: remove unnecessary includes of linux/config.h from drivers/scsi/
Date: Thu, 10 Aug 2006 21:41:13 -0400
Message-ID: <20060811014113.GC16454@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:26093 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S932419AbWHKBlX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Aug 2006 21:41:23 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id k7B1fMR4010484
	for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2006 21:41:22 -0400
Received: from nwo.kernelslacker.org (vpn-248-3.boston.redhat.com [10.13.248.3])
	by int-mx1.corp.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id k7B1fHgx003074
	for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2006 21:41:19 -0400
Received: from nwo.kernelslacker.org (localhost.localdomain [127.0.0.1])
	by nwo.kernelslacker.org (8.13.7/8.13.5) with ESMTP id k7B1fEZO018111
	for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2006 21:41:14 -0400
Received: (from davej@localhost)
	by nwo.kernelslacker.org (8.13.7/8.13.7/Submit) id k7B1fD3C018110
	for linux-scsi@vger.kernel.org; Thu, 10 Aug 2006 21:41:13 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

kbuild includes this automatically these days.

Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6.17.noarch/drivers/scsi/scsi.h~	2006-08-10 21:29:08.000000000 -0400
+++ linux-2.6.17.noarch/drivers/scsi/scsi.h	2006-08-10 21:29:10.000000000 -0400
@@ -20,8 +20,6 @@
 #ifndef _SCSI_H
 #define _SCSI_H
 
-#include <linux/config.h>	    /* for CONFIG_SCSI_LOGGING */
-
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_eh.h>
--- linux-2.6.17.noarch/drivers/scsi/aic7xxx_old.c~	2006-08-10 21:37:46.000000000 -0400
+++ linux-2.6.17.noarch/drivers/scsi/aic7xxx_old.c	2006-08-10 21:37:49.000000000 -0400
@@ -249,8 +249,6 @@
 #include <linux/stat.h>
 #include <linux/slab.h>        /* for kmalloc() */
 
-#include <linux/config.h>        /* for CONFIG_PCI */
-
 #define AIC7XXX_C_VERSION  "5.2.6"
 
 #define ALL_TARGETS -1
--- linux-2.6.17.noarch/drivers/scsi/hptiop.c~	2006-08-10 21:37:53.000000000 -0400
+++ linux-2.6.17.noarch/drivers/scsi/hptiop.c	2006-08-10 21:37:54.000000000 -0400
@@ -15,7 +15,6 @@
  *
  * For more information, visit http://www.highpoint-tech.com
  */
-#include <linux/config.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
--- linux-2.6.17.noarch/drivers/scsi/dpt_i2o.c~	2006-08-10 21:37:58.000000000 -0400
+++ linux-2.6.17.noarch/drivers/scsi/dpt_i2o.c	2006-08-10 21:38:00.000000000 -0400
@@ -46,7 +46,6 @@ MODULE_DESCRIPTION("Adaptec I2O RAID Dri
 
 #include <linux/stat.h>
 #include <linux/slab.h>		/* for kmalloc() */
-#include <linux/config.h>	/* for CONFIG_PCI */
 #include <linux/pci.h>		/* for PCI support */
 #include <linux/proc_fs.h>
 #include <linux/blkdev.h>
--- linux-2.6.17.noarch/drivers/scsi/libata-eh.c~	2006-08-10 21:38:05.000000000 -0400
+++ linux-2.6.17.noarch/drivers/scsi/libata-eh.c	2006-08-10 21:38:07.000000000 -0400
@@ -32,7 +32,6 @@
  *
  */
 
-#include <linux/config.h>
 #include <linux/kernel.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>

-- 
http://www.codemonkey.org.uk

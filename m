From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] janitor: remove unneeded includes (/scsi/)
Date: Wed, 17 Sep 2003 14:10:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030917141056.65b2f3fa.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:8638 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262841AbTIQVRh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Sep 2003 17:17:37 -0400
List-Id: linux-scsi@vger.kernel.org
To: jejb <james.bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org


Hi,
Please apply to 2.6.0-test5-current.
Thanks.


From: Randy Hron <rwhron@earthlink.net>


 linux-260-test5-kj-rddunlap/drivers/scsi/53c700.c   |    1 -
 linux-260-test5-kj-rddunlap/drivers/scsi/BusLogic.c |    1 -
 linux-260-test5-kj-rddunlap/drivers/scsi/aha152x.c  |    1 -
 linux-260-test5-kj-rddunlap/drivers/scsi/dmx3191d.c |    1 -
 linux-260-test5-kj-rddunlap/drivers/scsi/i60uscsi.c |    1 -
 5 files changed, 5 deletions(-)

diff -puN drivers/scsi/53c700.c~version_drivers_scsi drivers/scsi/53c700.c
--- linux-260-test5-kj/drivers/scsi/53c700.c~version_drivers_scsi	2003-09-10 17:07:25.000000000 -0700
+++ linux-260-test5-kj-rddunlap/drivers/scsi/53c700.c	2003-09-10 17:07:25.000000000 -0700
@@ -115,7 +115,6 @@
 #define NCR_700_VERSION "2.8"
 
 #include <linux/config.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/string.h>
diff -puN drivers/scsi/aha152x.c~version_drivers_scsi drivers/scsi/aha152x.c
--- linux-260-test5-kj/drivers/scsi/aha152x.c~version_drivers_scsi	2003-09-10 17:07:25.000000000 -0700
+++ linux-260-test5-kj-rddunlap/drivers/scsi/aha152x.c	2003-09-10 17:07:25.000000000 -0700
@@ -224,7 +224,6 @@
 #include <linux/sched.h>
 #include <asm/irq.h>
 #include <asm/io.h>
-#include <linux/version.h>
 #include <linux/blkdev.h>
 #include "scsi.h"
 #include "hosts.h"
diff -puN drivers/scsi/BusLogic.c~version_drivers_scsi drivers/scsi/BusLogic.c
--- linux-260-test5-kj/drivers/scsi/BusLogic.c~version_drivers_scsi	2003-09-10 17:07:25.000000000 -0700
+++ linux-260-test5-kj-rddunlap/drivers/scsi/BusLogic.c	2003-09-10 17:07:25.000000000 -0700
@@ -31,7 +31,6 @@
 #define BusLogic_DriverDate		"18 July 2002"
 
 #include <linux/config.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
diff -puN drivers/scsi/dmx3191d.c~version_drivers_scsi drivers/scsi/dmx3191d.c
--- linux-260-test5-kj/drivers/scsi/dmx3191d.c~version_drivers_scsi	2003-09-10 17:07:25.000000000 -0700
+++ linux-260-test5-kj-rddunlap/drivers/scsi/dmx3191d.c	2003-09-10 17:07:25.000000000 -0700
@@ -30,7 +30,6 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/stat.h>
-#include <linux/version.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 
diff -puN drivers/scsi/i60uscsi.c~version_drivers_scsi drivers/scsi/i60uscsi.c
--- linux-260-test5-kj/drivers/scsi/i60uscsi.c~version_drivers_scsi	2003-09-10 17:07:25.000000000 -0700
+++ linux-260-test5-kj-rddunlap/drivers/scsi/i60uscsi.c	2003-09-10 17:07:25.000000000 -0700
@@ -74,7 +74,6 @@
  *          - Fix allocation of scsi host structs and private data
  **************************************************************************/
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <asm/irq.h>
 #include <linux/pci.h>

_

--
~Randy

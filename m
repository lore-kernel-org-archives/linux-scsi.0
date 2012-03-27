From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] scsi: arm: fix compilation
Date: Tue, 27 Mar 2012 23:05:21 +0300
Message-ID: <20120327200521.GA4284@p183.telecom.by>
References: <20120327025100.GD26825@windriver.com>
 <1332838284.2883.22.camel@dabdike>
 <20120328014900.4ac23b9c65831393cae1eb1b@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55125 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab2C0UF1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Mar 2012 16:05:27 -0400
Content-Disposition: inline
In-Reply-To: <20120328014900.4ac23b9c65831393cae1eb1b@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Bottomley <jbottomley@parallels.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Add seq_file.h for seq_file stuff.
Broken by commit bb6c20445c1bdd1c49ac5e76801211116694e3b9
"[SCSI] arm: convert drivers to scsi proc_ops"

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/scsi/arm/arxescsi.c |    1 +
 drivers/scsi/arm/cumana_2.c |    1 +
 drivers/scsi/arm/eesox.c    |    1 +
 drivers/scsi/arm/fas216.c   |    1 +
 drivers/scsi/arm/powertec.c |    1 +
 5 files changed, 5 insertions(+)

--- a/drivers/scsi/arm/arxescsi.c
+++ b/drivers/scsi/arm/arxescsi.c
@@ -25,6 +25,7 @@
 #include <linux/ioport.h>
 #include <linux/proc_fs.h>
 #include <linux/unistd.h>
+#include <linux/seq_file.h>
 #include <linux/stat.h>
 #include <linux/delay.h>
 #include <linux/init.h>
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/blkdev.h>
 #include <linux/kernel.h>
+#include <linux/seq_file.h>
 #include <linux/string.h>
 #include <linux/ioport.h>
 #include <linux/proc_fs.h>
--- a/drivers/scsi/arm/eesox.c
+++ b/drivers/scsi/arm/eesox.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/blkdev.h>
 #include <linux/kernel.h>
+#include <linux/seq_file.h>
 #include <linux/string.h>
 #include <linux/ioport.h>
 #include <linux/proc_fs.h>
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -40,6 +40,7 @@
 #include <linux/string.h>
 #include <linux/ioport.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/delay.h>
 #include <linux/bitops.h>
 #include <linux/init.h>
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/blkdev.h>
 #include <linux/kernel.h>
+#include <linux/seq_file.h>
 #include <linux/string.h>
 #include <linux/ioport.h>
 #include <linux/proc_fs.h>

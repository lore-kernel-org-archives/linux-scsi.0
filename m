From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 27/36] aha1542: cleanup includes
Date: Fri,  6 Feb 2015 23:11:48 +0100
Message-ID: <1423260717-15944-28-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56970 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755314AbbBFWQH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:16:07 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8H-0006fF-JK
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:13 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 214b9f4..16cb6f9 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -11,23 +11,18 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/string.h>
-#include <linux/ioport.h>
 #include <linux/delay.h>
-#include <linux/proc_fs.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/isa.h>
 #include <linux/pnp.h>
-#include <linux/blkdev.h>
 #include <linux/slab.h>
-
+#include <linux/io.h>
 #include <asm/dma.h>
-#include <asm/io.h>
-
-#include "scsi.h"
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include "aha1542.h"
-#include <linux/stat.h>
 
 #ifdef DEBUG
 #define DEB(x) x
-- 
Ondrej Zary


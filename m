From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 2/2] pluto fix disable/enable irq
Date: Mon, 15 Oct 2007 13:16:05 -0700
Message-ID: <20071015131605.3678922d.randy.dunlap@oracle.com>
References: <4713A175.9020408@panasas.com>
	<4713A2DB.2000302@panasas.com>
	<20071015180949.GC25488@parisc-linux.org>
	<4713AEF0.5070706@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:57514 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbXJOUSz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 16:18:55 -0400
In-Reply-To: <4713AEF0.5070706@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@SteelEye.com>, "David S. Miller" <davem@davemloft.net>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <tomof@acm.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Pluto drivers uses disable/enable_irq(), so add prototypes for them.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/pluto.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.23-git7.orig/drivers/scsi/pluto.c
+++ linux-2.6.23-git7/drivers/scsi/pluto.c
@@ -14,6 +14,7 @@
 #include <linux/proc_fs.h>
 #include <linux/stat.h>
 #include <linux/init.h>
+#include <linux/interrupt.h>
 #ifdef CONFIG_KMOD
 #include <linux/kmod.h>
 #endif

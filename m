From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH] tmscim: Remove unused SCSI_IRQ_NONE macro definition
Date: Fri, 3 Oct 2014 11:44:30 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1410011654020.25690@nippy.intranet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:38981 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbaJCBpg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 21:45:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Kurt Garloff <garloff@suse.de>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-scsi@vger.kernel.org, trivial@kernel.org


Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---

This macro is only used in the NCR5380 drivers and they don't include
this header.

---
 drivers/scsi/tmscsim.h |    2 --
 1 file changed, 2 deletions(-)

Index: linux/drivers/scsi/tmscsim.h
===================================================================
--- linux.orig/drivers/scsi/tmscsim.h	2014-09-29 10:55:44.000000000 +1000
+++ linux/drivers/scsi/tmscsim.h	2014-10-01 16:33:25.000000000 +1000
@@ -10,8 +10,6 @@
 
 #include <linux/types.h>
 
-#define SCSI_IRQ_NONE 255
-
 #define MAX_ADAPTER_NUM 	4
 #define MAX_SG_LIST_BUF 	16	/* Not used */
 #define MAX_SCSI_ID		8

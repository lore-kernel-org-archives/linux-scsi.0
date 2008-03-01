From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 3/6] docbook: fix scsi source file
Date: Fri, 29 Feb 2008 22:02:50 -0800
Message-ID: <20080229220250.6488df42.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:58546 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbYCAGDI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Mar 2008 01:03:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lkml <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, torvalds <torvalds@linux-foundation.org>, jejb <James.Bottomley@HansenPartnership.com>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix docbook problem in SCSI source files.
These cause the generated docbook to be incorrect.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/scsi_scan.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- lin2625-rc3g2-kdoc.orig/drivers/scsi/scsi_scan.c
+++ lin2625-rc3g2-kdoc/drivers/scsi/scsi_scan.c
@@ -1577,8 +1577,7 @@ static void __scsi_scan_target(struct de
 }
 
 /**
- * scsi_scan_target - scan a target id, possibly including all LUNs on the
- *     target.
+ * scsi_scan_target - scan a target id, possibly including all LUNs on the target.
  * @parent:	host to scan
  * @channel:	channel to scan
  * @id:		target id to scan

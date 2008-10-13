From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] scsi: fix netlink kernel-doc
Date: Mon, 13 Oct 2008 09:15:09 -0700
Message-ID: <20081013091509.9e7a18b8.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:59752 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758813AbYJMQPT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Oct 2008 12:15:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <James.Bottomley@hansenpartnership.com>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warning: the function short description must be on one
line and the previous comment is not kernel-doc but it was confusing
scripts/kernel-doc.

Warning(lin2627-g3-kdocfixes//drivers/scsi/scsi_netlink.c:221): No description found for parameter 'skb'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/scsi_netlink.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- lin2627-g3-kdocfixes.orig/drivers/scsi/scsi_netlink.c
+++ lin2627-g3-kdocfixes/drivers/scsi/scsi_netlink.c
@@ -205,16 +205,13 @@ static struct notifier_block scsi_netlin
 };
 
 
-/**
+/*
  * GENERIC SCSI transport receive and event handlers
- **/
+ */
 
 /**
- * scsi_generic_msg_handler - receive message handler for GENERIC transport
- * 			 messages
- *
+ * scsi_generic_msg_handler - receive message handler for GENERIC transport messages
  * @skb:		socket receive buffer
- *
  **/
 static int
 scsi_generic_msg_handler(struct sk_buff *skb)

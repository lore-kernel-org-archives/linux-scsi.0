From: Rob Landley <rob@landley.net>
Subject: [PATCH 8/15] Update kerneldoc comments in drivers/scsi/scsi_netlink.c
Date: Fri, 26 Oct 2007 23:12:40 -0500
Message-ID: <200710262312.40829.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:35975
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751498AbXJ0DM4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Oct 2007 23:12:56 -0400
Received: from landley.net (localhost [127.0.0.1])
	by grelber.thyrsus.com (Postfix) with ESMTP id 8706373938
	for <linux-scsi@vger.kernel.org>; Fri, 26 Oct 2007 23:15:40 -0400 (EDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Rob Landley <rob@landley.net>

Update kerneldoc comments in drivers/scsi/scsi_netlink.c

Signed-off-by: Rob Landley <rob@landley.net>
---

 drivers/scsi/scsi_netlink.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff -r a868e8217782 drivers/scsi/scsi_netlink.c
--- a/drivers/scsi/scsi_netlink.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_netlink.c	Fri Oct 26 22:44:42 2007 -0500
@@ -32,11 +32,12 @@ EXPORT_SYMBOL_GPL(scsi_nl_sock);
 
 
 /**
- * scsi_nl_rcv_msg -
- *    Receive message handler. Extracts message from a receive buffer.
+ * scsi_nl_rcv_msg - Receive message handler.
+ * @skb:		socket receive buffer
+ *
+ * Description: Extracts message from a receive buffer.
  *    Validates message header and calls appropriate transport message handler
  *
- * @skb:		socket receive buffer
  *
  **/
 static void
@@ -99,9 +100,7 @@ next_msg:
 
 
 /**
- * scsi_nl_rcv_event -
- *    Event handler for a netlink socket.
- *
+ * scsi_nl_rcv_event - Event handler for a netlink socket.
  * @this:		event notifier block
  * @event:		event type
  * @ptr:		event payload
@@ -129,9 +128,7 @@ static struct notifier_block scsi_netlin
 
 
 /**
- * scsi_netlink_init -
- *    Called by SCSI subsystem to intialize the SCSI transport netlink
- *    interface
+ * scsi_netlink_init - Called by SCSI subsystem to intialize the SCSI transport netlink interface
  *
  **/
 void
@@ -160,9 +157,7 @@ scsi_netlink_init(void)
 
 
 /**
- * scsi_netlink_exit -
- *    Called by SCSI subsystem to disable the SCSI transport netlink
- *    interface
+ * scsi_netlink_exit - Called by SCSI subsystem to disable the SCSI transport netlink interface
  *
  **/
 void

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.

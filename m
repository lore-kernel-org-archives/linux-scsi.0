From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: [PATCH] SCSI/ibmvscsi: fix a typo in a source code comment
Date: Fri, 4 Dec 2009 20:43:37 +0100
Message-ID: <200912042043.37328.bart.vanassche@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:46812 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbZLDTnj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2009 14:43:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>

Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index e475b79..e3a18e0 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -40,7 +40,7 @@
  * (CRQ), which is just a buffer of 16 byte entries in the receiver's 
  * Senders cannot access the buffer directly, but send messages by
  * making a hypervisor call and passing in the 16 bytes.  The hypervisor
- * puts the message in the next 16 byte space in round-robbin fashion,
+ * puts the message in the next 16 byte space in round-robin fashion,
  * turns on the high order bit of the message (the valid bit), and 
  * generates an interrupt to the receiver (if interrupts are turned on.) 
  * The receiver just turns off the valid bit when they have copied out

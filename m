From: dann frazier <dannf@dannf.org>
Subject: [PATCH] typos in megaraid driver
Date: Sun, 16 Sep 2007 10:07:44 -0600
Message-ID: <20070916160744.GA3174@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel6.hp.com ([156.153.255.205]:42339 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbXIPQGp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Sep 2007 12:06:45 -0400
Received: from smtp2.fc.hp.com (smtp.fc.hp.com [15.11.136.114])
	by atlrel6.hp.com (Postfix) with ESMTP id 6EDE537991
	for <linux-scsi@vger.kernel.org>; Sun, 16 Sep 2007 12:06:44 -0400 (EDT)
Received: from ldl.fc.hp.com (ldl.fc.hp.com [15.11.146.30])
	by smtp2.fc.hp.com (Postfix) with ESMTP id 14774225897
	for <linux-scsi@vger.kernel.org>; Sun, 16 Sep 2007 16:06:44 +0000 (UTC)
Received: from localhost (ldl.fc.hp.com [127.0.0.1])
	by ldl.fc.hp.com (Postfix) with ESMTP id DBCFE39C1A3
	for <linux-scsi@vger.kernel.org>; Sun, 16 Sep 2007 10:06:43 -0600 (MDT)
Received: from ldl.fc.hp.com ([127.0.0.1])
	by localhost (ldl.fc.hp.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jm8FfHzHZcrM for <linux-scsi@vger.kernel.org>;
	Sun, 16 Sep 2007 10:06:42 -0600 (MDT)
Received: from krebs (krebs.dannf [10.8.0.7])
	by ldl.fc.hp.com (Postfix) with ESMTP id 9CF8C39C1A0
	for <linux-scsi@vger.kernel.org>; Sun, 16 Sep 2007 10:06:42 -0600 (MDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Cleanup a few typos in megaraid

Signed-off-by: dann frazier <dannf@dannf.org>

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index c6a53dc..4963b96 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -500,7 +500,7 @@ megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	// Start the mailbox based controller
 	if (megaraid_init_mbox(adapter) != 0) {
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid: maibox adapter did not initialize\n"));
+			"megaraid: mailbox adapter did not initialize\n"));
 
 		goto out_free_adapter;
 	}
@@ -972,8 +972,8 @@ megaraid_fini_mbox(adapter_t *adapter)
  * megaraid_alloc_cmd_packets - allocate shared mailbox
  * @adapter		: soft state of the raid controller
  *
- * Allocate and align the shared mailbox. This maibox is used to issue
- * all the commands. For IO based controllers, the mailbox is also regsitered
+ * Allocate and align the shared mailbox. This mailbox is used to issue
+ * all the commands. For IO based controllers, the mailbox is also registered
  * with the FW. Allocate memory for all commands as well.
  * This is our big allocator.
  */
diff --git a/drivers/scsi/megaraid/megaraid_mbox.h b/drivers/scsi/megaraid/megaraid_mbox.h
index 626459d..2e760c2 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.h
+++ b/drivers/scsi/megaraid/megaraid_mbox.h
@@ -116,7 +116,7 @@
  * @raw_mbox		: raw mailbox pointer
  * @mbox		: mailbox
  * @mbox64		: extended mailbox
- * @mbox_dma_h		: maibox dma address
+ * @mbox_dma_h		: mailbox dma address
  * @sgl64		: 64-bit scatter-gather list
  * @sgl32		: 32-bit scatter-gather list
  * @sgl_dma_h		: dma handle for the scatter-gather list

From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] ibmvfc: remove unused tag variable
Date: Tue, 25 Nov 2014 15:50:10 +0100
Message-ID: <1416927010-6036-2-git-send-email-hch@lst.de>
References: <1416927010-6036-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:54189 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaKYOuT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Nov 2014 09:50:19 -0500
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XtHRa-0001WQ-8o
	for linux-scsi@vger.kernel.org; Tue, 25 Nov 2014 14:50:18 +0000
In-Reply-To: <1416927010-6036-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index f58c6d8..8ac49cf 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1615,7 +1615,6 @@ static int ibmvfc_queuecommand_lck(struct scsi_cmnd *cmnd,
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	struct ibmvfc_cmd *vfc_cmd;
 	struct ibmvfc_event *evt;
-	u8 tag[2];
 	int rc;
 
 	if (unlikely((rc = fc_remote_port_chkready(rport))) ||
-- 
1.9.1


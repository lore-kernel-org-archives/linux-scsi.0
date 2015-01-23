From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 13/48] hpsa: downgrade the Waiting for no-op print to
 dev_info
Date: Fri, 23 Jan 2015 16:42:11 -0600
Message-ID: <20150123224211.14919.45209.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:34553 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbbAWWnF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:43:05 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

There is nothing worrisome about the "Waiting for controller to
respond to no-op" print, so use dev_info rather than dev_warn.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 85b3d73..ec2503a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6424,7 +6424,7 @@ static int hpsa_init_reset_devices(struct pci_dev *pdev)
 		goto out_disable;
 
 	/* Now try to get the controller to respond to a no-op */
-	dev_warn(&pdev->dev, "Waiting for controller to respond to no-op\n");
+	dev_info(&pdev->dev, "Waiting for controller to respond to no-op\n");
 	for (i = 0; i < HPSA_POST_RESET_NOOP_RETRIES; i++) {
 		if (hpsa_noop(pdev) == 0)
 			break;


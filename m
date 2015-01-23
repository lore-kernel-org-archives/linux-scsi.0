From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 10/48] hpsa: remove 0x from queue depth print which is in
 decimal
Date: Fri, 23 Jan 2015 16:41:56 -0600
Message-ID: <20150123224156.14919.23268.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:34387 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbbAWWmu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:42:50 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

The queue depth printed at startup is in decimal, so
shouldn't have a 0x prefix.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 97bb718..fbeef5b 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5931,7 +5931,7 @@ static void print_cfg_table(struct device *dev, struct CfgTable __iomem *tb)
 	       readl(&(tb->HostWrite.CoalIntDelay)));
 	dev_info(dev, "   Coalesce Interrupt Count = 0x%x\n",
 	       readl(&(tb->HostWrite.CoalIntCount)));
-	dev_info(dev, "   Max outstanding commands = 0x%d\n",
+	dev_info(dev, "   Max outstanding commands = %d\n",
 	       readl(&(tb->CmdsOutMax)));
 	dev_info(dev, "   Bus Types = 0x%x\n", readl(&(tb->BusTypes)));
 	for (i = 0; i < 16; i++)


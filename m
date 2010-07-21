From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 12/19] be2iscsi: Remove debug print in IO path
Date: Thu, 22 Jul 2010 04:27:16 +0530
Message-ID: <20100721225706.GA9622@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:25382 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755065Ab0GUW5B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jul 2010 18:57:01 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

 This patch removes a Debug Print in the IO path

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index fdd9161..b70b4ba 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3744,8 +3744,6 @@ static int beiscsi_task_xmit(struct iscsi_task *task)
 		SE_DEBUG(DBG_LVL_1, " scsi_dma_map Failed\n")
 		return num_sg;
 	}
-	SE_DEBUG(DBG_LVL_4, "xferlen=0x%08x scmd=%p num_sg=%d sernum=%lu\n",
-		  (scsi_bufflen(sc)), sc, num_sg, sc->serial_number);
 	xferlen = scsi_bufflen(sc);
 	sg = scsi_sglist(sc);
 	if (sc->sc_data_direction == DMA_TO_DEVICE) {
-- 
1.6.5.2


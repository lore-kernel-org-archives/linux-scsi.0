From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 05/10] libfc: two minor changes in comments
Date: Wed, 27 Jul 2011 15:10:44 -0700
Message-ID: <20110727221044.23675.61830.stgit@localhost6.localdomain6>
References: <20110727221018.23675.3551.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24862 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756017Ab1G0WKo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2011 18:10:44 -0400
In-Reply-To: <20110727221018.23675.3551.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hillf Danton <dhillf@gmail.com>

From: Hillf Danton <dhillf@gmail.com>

One change is to cleanup typo in comment for fc_fcp_recv(), another corrects
the misleading comment for fc_fcp_abts_resp().

[ Patch reworked by Robert Love due to invalid patch format ]

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 41f7070..57311d0 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -690,7 +690,7 @@ static int fc_fcp_send_data(struct fc_fcp_pkt *fsp, struct fc_seq *seq,
 }
 
 /**
- * fc_fcp_abts_resp() - Send an ABTS response
+ * fc_fcp_abts_resp() - Receive an ABTS response
  * @fsp: The FCP packet that is being aborted
  * @fp:	 The response frame
  */
@@ -730,7 +730,7 @@ static void fc_fcp_abts_resp(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 }
 
 /**
- * fc_fcp_recv() - Reveive an FCP frame
+ * fc_fcp_recv() - Receive an FCP frame
  * @seq: The sequence the frame is on
  * @fp:	 The received frame
  * @arg: The related FCP packet


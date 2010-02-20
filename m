From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 5/7] be2iscsi: Remove debug code V2
Date: Sat, 20 Feb 2010 08:04:28 +0530
Message-ID: <20100220023418.GA13703@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:53560 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754435Ab0BTCe1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2010 21:34:27 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

 This patch removes some debug lines which are unnecessary and
also aligns some lines in code

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |    4 ++--
 drivers/scsi/be2iscsi/be_main.c  |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 29a3aaf..c3928cb 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -482,7 +482,7 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 	tag = mgmt_open_connection(phba, dst_addr, beiscsi_ep);
 	if (!tag) {
 		SE_DEBUG(DBG_LVL_1,
-			 "mgmt_invalidate_connection Failed for cid=%d \n",
+			 "mgmt_open_connection Failed for cid=%d \n",
 			 beiscsi_ep->ep_cid);
 	} else {
 		wait_event_interruptible(phba->ctrl.mcc_wait[tag],
@@ -701,7 +701,7 @@ void beiscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 	if (!tag) {
 		SE_DEBUG(DBG_LVL_1,
 			 "mgmt_invalidate_connection Failed for cid=%d \n",
-			 beiscsi_ep->ep_cid);
+			  beiscsi_ep->ep_cid);
 	} else {
 		wait_event_interruptible(phba->ctrl.mcc_wait[tag],
 					 phba->ctrl.mcc_numtag[tag]);
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index aee3734..b5dca45 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3779,7 +3779,6 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 			" Failed in beiscsi_hba_alloc \n");
 		goto disable_pci;
 	}
-	SE_DEBUG(DBG_LVL_8, " phba = %p \n", phba);
 
 	switch (pcidev->device) {
 	case BE_DEVICE_ID1:
-- 
1.6.4


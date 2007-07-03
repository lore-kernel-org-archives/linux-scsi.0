From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] lpfc: convert to use the data buffer accessors - part 2
Date: Tue, 03 Jul 2007 18:12:35 +0300
Message-ID: <468A6763.3020102@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:46700 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757513AbXGCPMu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jul 2007 11:12:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Smart <James.Smart@emulex.com>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>


 This is an addendum to:
 commit a0b4f78f9a4c869e9b29f254054ad7441cb40bbf
 Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    [SCSI] lpfc: convert to use the data buffer accessors

 One place was missed in the merge

 Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 5d2e3de..3d35eae 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -506,7 +506,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 					"underrun converted to error "
 					"Data: x%x x%x x%x\n",
 					phba->brd_no, vpi, cmnd->cmnd[0],
-					cmnd->request_bufflen,
+					scsi_bufflen(cmnd),
 					scsi_get_resid(cmnd), cmnd->underflow);
 			host_status = DID_ERROR;
 		}
-- 
1.5.2.2.249.g45fd



From: Joe Perches <joe@perches.com>
Subject: [PATCH 44/62] drivers/scsi/lpfc/lpfc_ct.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:49 -0700
Message-ID: <2f7fa59e8fc0ade08d9f23a72d8e1907350eb24d.1246173682.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1158 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244AbZF1Q2A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2009 12:28:00 -0400
In-Reply-To: <cover.1246173664.git.joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>, James Smart <james.smart@emulex.com>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/lpfc/lpfc_ct.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 0e532f0..4d935ba 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1205,7 +1205,7 @@ lpfc_ns_cmd(struct lpfc_vport *vport, int cmdcode,
 		vport->ct_flags &= ~FC_CT_RFF_ID;
 		CtReq->CommandResponse.bits.CmdRsp =
 		    be16_to_cpu(SLI_CTNS_RFF_ID);
-		CtReq->un.rff.PortId = cpu_to_be32(vport->fc_myDID);;
+		CtReq->un.rff.PortId = cpu_to_be32(vport->fc_myDID);
 		CtReq->un.rff.fbits = FC4_FEATURE_INIT;
 		CtReq->un.rff.type_code = FC_FCP_DATA;
 		cmpl = lpfc_cmpl_ct_cmd_rff_id;
-- 
1.6.3.1.10.g659a0.dirty


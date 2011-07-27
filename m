From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH RESEND v2 5/9] bnx2fc: Enable support for sequence level
 error recovery
Date: Wed, 27 Jul 2011 11:32:09 -0700
Message-ID: <1311791533-27745-6-git-send-email-bprakash@broadcom.com>
References: <1311791533-27745-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1110 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595Ab1G0Scd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2011 14:32:33 -0400
In-Reply-To: <1311791533-27745-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, devel@open-fcoe.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Driver advertises its support for 'retry' bit and 'conf completion' bit in PRLI
params to enable support for 'sequence level error recovery'

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 65561fc..78e136f 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -908,11 +908,8 @@ static int bnx2fc_lport_config(struct fc_lport *lport)
 	lport->e_d_tov = 2 * 1000;
 	lport->r_a_tov = 10 * 1000;
 
-	/* REVISIT: enable when supporting tape devices
 	lport->service_params = (FCP_SPPF_INIT_FCN | FCP_SPPF_RD_XRDY_DIS |
 				FCP_SPPF_RETRY | FCP_SPPF_CONF_COMPL);
-	*/
-	lport->service_params = (FCP_SPPF_INIT_FCN | FCP_SPPF_RD_XRDY_DIS);
 	lport->does_npiv = 1;
 
 	memset(&lport->rnid_gen, 0, sizeof(struct fc_els_rnid_gen));
-- 
1.7.0.6



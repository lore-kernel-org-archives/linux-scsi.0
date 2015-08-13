From: <anil.gurumurthy@qlogic.com>
Subject: [PATCH 1/2] bfa: Fix indentation
Date: Thu, 13 Aug 2015 06:41:51 -0400
Message-ID: <1439462512-1911-2-git-send-email-anil.gurumurthy@qlogic.com>
References: <1439462512-1911-1-git-send-email-anil.gurumurthy@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:64136 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345AbbHML2b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Aug 2015 07:28:31 -0400
In-Reply-To: <1439462512-1911-1-git-send-email-anil.gurumurthy@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, sudarsana.kalluru@qlogic.com, Anil Gurumurthy <anil.gurumurthy@qlogic.com>

From: Anil Gurumurthy <anil.gurumurthy@qlogic.com>

Signed-off-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Tested-by : Sudarasana Kalluru <sudarsana.kalluru@qlogic.com>
---
 drivers/scsi/bfa/bfa_ioc.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 315d6d6..4e71044 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -3665,19 +3665,19 @@ bfa_cb_sfp_state_query(struct bfa_sfp_s *sfp)
 		if (sfp->state_query_cbfn)
 			sfp->state_query_cbfn(sfp->state_query_cbarg,
 					sfp->status);
-			sfp->media = NULL;
-		}
+		sfp->media = NULL;
+	}
 
-		if (sfp->portspeed) {
-			sfp->status = bfa_sfp_speed_valid(sfp, sfp->portspeed);
-			if (sfp->state_query_cbfn)
-				sfp->state_query_cbfn(sfp->state_query_cbarg,
-						sfp->status);
-				sfp->portspeed = BFA_PORT_SPEED_UNKNOWN;
-		}
+	if (sfp->portspeed) {
+		sfp->status = bfa_sfp_speed_valid(sfp, sfp->portspeed);
+		if (sfp->state_query_cbfn)
+			sfp->state_query_cbfn(sfp->state_query_cbarg,
+					sfp->status);
+		sfp->portspeed = BFA_PORT_SPEED_UNKNOWN;
+	}
 
-		sfp->state_query_lock = 0;
-		sfp->state_query_cbfn = NULL;
+	sfp->state_query_lock = 0;
+	sfp->state_query_cbfn = NULL;
 }
 
 /*
-- 
1.7.10.4


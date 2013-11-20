From: <vmohan@brocade.com>
Subject: [PATCH 6/8] bfa: change FC_ELS_TOV to 20sec
Date: Tue, 19 Nov 2013 23:05:44 -0800
Message-ID: <1384931146-3702-7-git-send-email-vmohan@brocade.com>
References: <1384931146-3702-1-git-send-email-vmohan@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:7009 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751954Ab3KTHgE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Nov 2013 02:36:04 -0500
In-Reply-To: <1384931146-3702-1-git-send-email-vmohan@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: agurumur@brocade.com, james.bottomley@hansenpartnership.com

From: Vijaya Mohan Guvva <vmohan@brocade.com>

As per the FCP specs, the timeout for issuing ABTS is 20 sec; not 21
sec. Hence setting the TOV to 20 sec.

Signed-off-by: Vijaya Mohan Guvva <vmohan@brocade.com>
---
 drivers/scsi/bfa/bfa_fc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_fc.h b/drivers/scsi/bfa/bfa_fc.h
index 562ef73..64069a0 100644
--- a/drivers/scsi/bfa/bfa_fc.h
+++ b/drivers/scsi/bfa/bfa_fc.h
@@ -1026,7 +1026,7 @@ struct fc_alpabm_s {
 #define FC_ED_TOV	2
 #define FC_REC_TOV	(FC_ED_TOV + 1)
 #define FC_RA_TOV	10
-#define FC_ELS_TOV	((2 * FC_RA_TOV) + 1)
+#define FC_ELS_TOV	(2 * FC_RA_TOV)
 #define FC_FCCT_TOV	(3 * FC_RA_TOV)
 
 /*
-- 
1.8.2.1


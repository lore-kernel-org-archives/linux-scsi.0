From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 06/14] lpfc: Code cleanup for lpfc_enable_rrq parameter
Date: Thu, 11 Aug 2016 11:35:53 -0700
Message-ID: <57acc589.4lRyP2YikZRQN1SN%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:33477 "EHLO
	mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbcHKSf4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2016 14:35:56 -0400
Received: by mail-qk0-f169.google.com with SMTP id t7so4358992qkh.0
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2016 11:35:56 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id x42sm2208331qtc.29.2016.08.11.11.35.54
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Aug 2016 11:35:55 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Code cleanup for lpfc_enable_rrq parameter

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index e5092dc..22a66c7 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -2759,18 +2759,14 @@ LPFC_ATTR_R(enable_npiv, 1, 0, 1,
 LPFC_ATTR_R(fcf_failover_policy, 1, 1, 2,
 	"FCF Fast failover=1 Priority failover=2");
 
-int lpfc_enable_rrq = 2;
-module_param(lpfc_enable_rrq, int, S_IRUGO);
-MODULE_PARM_DESC(lpfc_enable_rrq, "Enable RRQ functionality");
-lpfc_param_show(enable_rrq);
 /*
 # lpfc_enable_rrq: Track XRI/OXID reuse after IO failures
 #	0x0 = disabled, XRI/OXID use not tracked.
 #	0x1 = XRI/OXID reuse is timed with ratov, RRQ sent.
 #	0x2 = XRI/OXID reuse is timed with ratov, No RRQ sent.
 */
-lpfc_param_init(enable_rrq, 2, 0, 2);
-static DEVICE_ATTR(lpfc_enable_rrq, S_IRUGO, lpfc_enable_rrq_show, NULL);
+LPFC_ATTR_R(enable_rrq, 2, 0, 2,
+	"Enable RRQ functionality");
 
 /*
 # lpfc_suppress_link_up:  Bring link up at initialization
-- 
2.5.0


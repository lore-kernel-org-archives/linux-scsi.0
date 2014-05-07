From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH] iscsi_ibft: search for broadcom specific ibft sign
Date: Wed, 7 May 2014 05:00:20 -0400
Message-ID: <1399453220-21663-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:41977 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754715AbaEGJaJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 May 2014 05:30:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu, pjones@redhat.com, konrad@kernel.org
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, giridhar.malavali@qlogic.com, iscsi-driver@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Broadcom iscsi offload firmware uses a non standard ibft sign of "BIFT".
This patch modifies the ibft search code to search for "BIFT" along
with the other possible values.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Acked-by: Kevin Tran <ktran@broadcom.com>
Acked-by: Eddie Wai <eddie.wai@broadcom.com>
---
 drivers/firmware/iscsi_ibft.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
index 3ee852c..071c2c9 100644
--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -756,6 +756,7 @@ static const struct {
 	 */
 	{ ACPI_SIG_IBFT },
 	{ "iBFT" },
+	{ "BIFT" },	/* Broadcom iSCSI Offload */
 };
 
 static void __init acpi_find_ibft_region(void)
-- 
1.8.2.GIT


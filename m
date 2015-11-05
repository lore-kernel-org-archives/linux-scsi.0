From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: [PATCH 2/2] megaraid_sas: Fix sparse warning
Date: Thu,  5 Nov 2015 21:17:38 +0530
Message-ID: <1446738458-12425-3-git-send-email-Sumit.Saxena@avagotech.com>
References: <1446738458-12425-1-git-send-email-Sumit.Saxena@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34390 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030685AbbKEPsO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2015 10:48:14 -0500
Received: by padhx2 with SMTP id hx2so82778189pad.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2015 07:48:14 -0800 (PST)
In-Reply-To: <1446738458-12425-1-git-send-email-Sumit.Saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jbottomley@odin.com, martin.petersen@oracle.com, thenzl@redhat.com
Cc: kashyap.desai@avagotech.com, Sumit Saxena <sumit.saxena@avagotech.com>

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 72c731d..bdc2606 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1865,7 +1865,7 @@ megasas_build_syspd_fusion(struct megasas_instance *instance,
 		/* Want to send all IO via FW path */
 		pRAID_Context->VirtualDiskTgtId = cpu_to_le16(device_id);
 		pRAID_Context->configSeqNum = 0;
-		io_request->DevHandle = le16_to_cpu(0xFFFF);
+		io_request->DevHandle = cpu_to_le16(0xFFFF);
 	}
 
 	cmd->request_desc->SCSIIO.DevHandle = io_request->DevHandle;
-- 
1.7.1


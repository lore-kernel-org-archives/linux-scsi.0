From: Adam Radford <aradford@gmail.com>
Subject: [PATCH 2/5] megaraid_sas: Remove unused variables in megasas_instance
Date: Wed,  9 Jul 2014 15:17:55 -0700
Message-ID: <1404944278-11535-3-git-send-email-aradford@gmail.com>
References: <1404944278-11535-1-git-send-email-aradford@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:32929 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157AbaGIWTU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2014 18:19:20 -0400
Received: by mail-pd0-f177.google.com with SMTP id y10so9587597pdj.22
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jul 2014 15:19:20 -0700 (PDT)
In-Reply-To: <1404944278-11535-1-git-send-email-aradford@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, uday.lingala@avagotech.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com
Cc: Adam Radford <aradford@gmail.com>

The following patch for megaraid_sas removes some unused variables from the megasas_instance structure.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Adam Radford <aradford@gmail.com>
---
 drivers/scsi/megaraid/megaraid_sas.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 32166c2..7d722fb 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1633,8 +1633,6 @@ struct megasas_instance {
 	struct timer_list sriov_heartbeat_timer;
 	char skip_heartbeat_timer_del;
 	u8 requestorId;
-	u64 initiator_sas_address;
-	u64 ld_sas_address[64];
 	char PlasmaFW111;
 	char mpio;
 	int throttlequeuedepth;
-- 
1.7.11.7


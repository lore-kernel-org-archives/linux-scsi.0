From: Adam Radford <aradford@gmail.com>
Subject: [PATCH 2/4] megaraid_sas: Removed unused variables in megasas_instance
Date: Mon, 30 Jun 2014 17:19:56 -0700
Message-ID: <1404173998-24363-3-git-send-email-aradford@gmail.com>
References: <1404173998-24363-1-git-send-email-aradford@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:43100 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaGAAVH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jun 2014 20:21:07 -0400
Received: by mail-pd0-f173.google.com with SMTP id r10so9051399pdi.18
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jun 2014 17:21:07 -0700 (PDT)
In-Reply-To: <1404173998-24363-1-git-send-email-aradford@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com
Cc: Adam Radford <aradford@gmail.com>

James/linux-scsi,

The following patch for megaraid_sas removes some unused variables from the megasas_instance structure.

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


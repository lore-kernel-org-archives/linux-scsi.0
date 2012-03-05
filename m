From: Sathisha Nanjappa <sathisha.nanjappa@hp.com>
Subject: [PATCH]     Corrected the constant in comparison to a hexadecimal.
Date: Mon,  5 Mar 2012 12:13:19 -0800
Message-ID: <1330978399-32081-2-git-send-email-sathisha.nanjappa@hp.com>
References: <1330978399-32081-1-git-send-email-sathisha.nanjappa@hp.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:25853 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757494Ab2CEUNy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Mar 2012 15:13:54 -0500
Received: from g1t0039.austin.hp.com (g1t0039.austin.hp.com [16.236.32.45])
	by g1t0026.austin.hp.com (Postfix) with ESMTP id 27AF3C26F
	for <linux-scsi@vger.kernel.org>; Mon,  5 Mar 2012 20:13:54 +0000 (UTC)
In-Reply-To: <1330978399-32081-1-git-send-email-sathisha.nanjappa@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sathisha Nanjappa <sathisha.nanjappa@hp.com>

    Bug 42142 - mpt2sas: Number specified in wrong base
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 0b2c955..f9a1244 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -657,7 +657,7 @@ _base_sas_log_info(struct MPT2SAS_ADAPTER *ioc , u32 log_info)
 		return;
 
 	/* eat the loginfos associated with task aborts */
-	if (ioc->ignore_loginfos && (log_info == 30050000 || log_info ==
+	if (ioc->ignore_loginfos && (log_info == 0x30050000 || log_info ==
 	    0x31140000 || log_info == 0x31130000))
 		return;
 
-- 
1.7.7.6


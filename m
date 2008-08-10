From: akpm@linux-foundation.org
Subject: [patch 2/4] scsi: megaraid_sas: add the shutdown DCMD cmd to driver shutdown routine
Date: Sun, 10 Aug 2008 12:42:37 -0700
Message-ID: <200808101942.m7AJgbnf029517@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753373AbYHJTnM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Aug 2008 15:43:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, Bo.Yang@lsi.com, bo.yang@lsi.com

From: "Yang, Bo" <Bo.Yang@lsi.com>

Add the shutdown DCMD cmd to driver shutdown routine to make megaraid sas
FW shutdown proper.

Signed-off-by: Bo Yang<bo.yang@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/megaraid_sas.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-add-the-shutdown-dcmd-cmd-to-driver-shutdown-routine drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-add-the-shutdown-dcmd-cmd-to-driver-shutdown-routine
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -2863,6 +2863,7 @@ static void megasas_shutdown(struct pci_
 {
 	struct megasas_instance *instance = pci_get_drvdata(pdev);
 	megasas_flush_cache(instance);
+	megasas_shutdown_controller(instance, MR_DCMD_CTRL_SHUTDOWN);
 }
 
 /**
_

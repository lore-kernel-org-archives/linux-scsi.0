From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 04/14] megaraid_sas: Reset ldio_outstanding in megasas_resume
Date: Fri,  5 Jan 2018 05:27:39 -0800
Message-ID: <1515158869-26693-5-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:35428 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751731AbeAEN3S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jan 2018 08:29:18 -0500
Received: by mail-pl0-f68.google.com with SMTP id b96so3047583pli.2
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jan 2018 05:29:18 -0800 (PST)
In-Reply-To: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 38120917c609..424858874d57 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6708,6 +6708,7 @@ megasas_resume(struct pci_dev *pdev)
 	 */
 
 	atomic_set(&instance->fw_outstanding, 0);
+	atomic_set(&instance->ldio_outstanding, 0);
 
 	/* Now re-enable MSI-X */
 	if (instance->msix_vectors) {
-- 
2.14.1

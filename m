From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 14/17] scsi: arcmsr: fix grammar error
Date: Tue, 05 Dec 2017 10:18:47 +0800
Message-ID: <1512440327.4577.75.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:39399 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752773AbdLEKS4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Dec 2017 05:18:56 -0500
Received: by mail-it0-f43.google.com with SMTP id 68so268299ite.4
        for <linux-scsi@vger.kernel.org>; Tue, 05 Dec 2017 02:18:56 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, sfr@canb.auug.org.au

From: Ching Huang <ching2048@areca.com.tw>

fix grammar error.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2017-12-05 11:44:52.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2017-12-05 11:44:36.000000000 +0800
@@ -4453,7 +4453,7 @@ static int arcmsr_bus_reset(struct scsi_
 
 	if (acb->acb_flags & ACB_F_BUS_RESET) {
 		long timeout;
-		pr_notice("arcmsr: there is an bus reset eh proceeding...\n");
+		pr_notice("arcmsr: there is a bus reset eh proceeding...\n");
 		timeout = wait_event_timeout(wait_q, (acb->acb_flags
 			& ACB_F_BUS_RESET) == 0, 220 * HZ);
 		if (timeout)

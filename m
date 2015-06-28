From: Rudhresh <rudhresh.jk@gmail.com>
Subject: [PATCH] SCSI: dtc: Fixed a brace issue on return 0
Date: Sun, 28 Jun 2015 17:14:56 +0530
Message-ID: <1435491896-9755-1-git-send-email-rudhresh.jk@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:33584 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbbF1LpJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2015 07:45:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: fthain@telegraphics.com.au
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, rudhresh <rudhresh.jk@gmail.com>

From: rudhresh <rudhresh.jk@gmail.com>

Return is not a function so parenthesis is not required

Signed-off-by: Rudhresh <rudhresh.jk@gmail.com>
---
 drivers/scsi/dtc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/dtc.c b/drivers/scsi/dtc.c
index 4c74c7b..c793ecf 100644
--- a/drivers/scsi/dtc.c
+++ b/drivers/scsi/dtc.c
@@ -363,7 +363,7 @@ static inline int NCR5380_pread(struct Scsi_Host *instance, unsigned char *dst,
 	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 	if (i > hostdata->spin_max_r)
 		hostdata->spin_max_r = i;
-	return (0);
+	return 0;
 }
 
 /****************************************************************
@@ -417,7 +417,7 @@ static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src,
 	rtrc(0);
 	if (i > hostdata->spin_max_w)
 		hostdata->spin_max_w = i;
-	return (0);
+	return 0;
 }
 
 MODULE_LICENSE("GPL");
-- 
1.8.4.5


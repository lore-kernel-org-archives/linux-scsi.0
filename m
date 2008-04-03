From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 10/21] qla2xxx: Use PCI-SIG nomenclature for PCIe bandwidth units.
Date: Thu,  3 Apr 2008 13:13:21 -0700
Message-ID: <1207253612-15538-10-git-send-email-andrew.vasquez@qlogic.com>
References: <20080403201152.GB8033@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6416 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074AbYDCUNk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 16:13:40 -0400
In-Reply-To: <20080403201152.GB8033@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c0f6f66..ba7d2ca 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -249,9 +249,9 @@ qla24xx_pci_info_str(struct scsi_qla_host *ha, char *str)
 
 		strcpy(str, "PCIe (");
 		if (lspeed == 1)
-			strcat(str, "2.5Gb/s ");
+			strcat(str, "2.5GT/s ");
 		else if (lspeed == 2)
-			strcat(str, "5.0Gb/s ");
+			strcat(str, "5.0GT/s ");
 		else
 			strcat(str, "<unknown> ");
 		snprintf(lwstr, sizeof(lwstr), "x%d)", lwidth);
-- 
1.5.5.rc2


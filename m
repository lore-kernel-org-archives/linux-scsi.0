From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/6] qla2xxx: Allocate enough space for the full PCI descriptor.
Date: Sun, 12 Aug 2007 18:22:52 -0700
Message-ID: <11869681773166-git-send-email-andrew.vasquez@qlogic.com>
References: <20070813012218.GD1067@plap.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:31557 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764944AbXHMBW5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Aug 2007 21:22:57 -0400
In-Reply-To: <20070813012218.GD1067@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 93c0c7e..acca898 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1564,7 +1564,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct Scsi_Host *host;
 	scsi_qla_host_t *ha;
 	unsigned long	flags = 0;
-	char pci_info[20];
+	char pci_info[30];
 	char fw_str[30];
 	struct scsi_host_template *sht;
 
-- 
1.5.3.rc4.41.g7efe


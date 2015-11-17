From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 40/52] atp870u: Remove unused irq from struct atp_unit
Date: Tue, 17 Nov 2015 19:24:16 +0100
Message-ID: <1447784668-23713-41-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56526 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932126AbbKQSgu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:36:50 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/atp870u.h b/drivers/scsi/atp870u.h
index 5cf6256..c3c6c13 100644
--- a/drivers/scsi/atp870u.h
+++ b/drivers/scsi/atp870u.h
@@ -26,7 +26,6 @@ struct atp_unit
 	unsigned long baseport;
 	unsigned long ioport[2];
 	unsigned long pciport[2];
-	unsigned long irq;
 	unsigned char last_cmd[2];
 	unsigned char in_snd[2];
 	unsigned char in_int[2];
-- 
Ondrej Zary


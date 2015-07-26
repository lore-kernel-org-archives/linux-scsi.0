From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 40/52] atp870u: Remove unused irq from struct atp_unit
Date: Sun, 26 Jul 2015 22:24:47 +0200
Message-ID: <1437942299-26674-41-git-send-email-linux@rainbow-software.org>
References: <1437942299-26674-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56678 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755475AbbGZU5O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Jul 2015 16:57:14 -0400
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1ZJSU0-0003IN-4I
	for linux-scsi@vger.kernel.org; Sun, 26 Jul 2015 22:25:16 +0200
In-Reply-To: <1437942299-26674-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

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


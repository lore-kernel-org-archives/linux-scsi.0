From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 11/21] lpfc: Correct RDP response Revision location
Date: Wed, 06 Jul 2016 12:36:04 -0700
Message-ID: <577d5da4.qF0SkwMSM91wH60d%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38585 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651AbcGFTgJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 15:36:09 -0400
Received: by mail-wm0-f45.google.com with SMTP id r201so5685514wme.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jul 2016 12:36:09 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id i74sm7905183wmg.21.2016.07.06.12.36.06
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jul 2016 12:36:07 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Correct RDP response Revision location

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index c99c2b3..8226543 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1239,8 +1239,8 @@ struct fc_rdp_opd_sfp_info {
 	uint8_t            vendor_name[16];
 	uint8_t            model_number[16];
 	uint8_t            serial_number[16];
-	uint8_t            reserved[2];
 	uint8_t            revision[2];
+	uint8_t            reserved[2];
 	uint8_t            date[8];
 };
 
-- 
2.5.0


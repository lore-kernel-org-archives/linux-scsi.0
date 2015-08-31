From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 01/14] lpfc: fix model description
Date: Mon, 31 Aug 2015 16:48:08 -0400
Message-ID: <55e4bd88.eMQzUsAqXxOF6Qi2%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:35328 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbbHaUsY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2015 16:48:24 -0400
Received: by qgz60 with SMTP id 60so15948022qgz.2
        for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2015 13:48:24 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by smtp.gmail.com with ESMTPSA id 95sm6632489qgt.12.2015.08.31.13.48.22
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 31 Aug 2015 13:48:22 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


From: Sebastian Herbszt <herbszt@gmx.de>

Remove trailing space from model description.

Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index f962118..1992e74 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2253,7 +2253,7 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
 				phba->Port);
 		else if (max_speed == 0)
 			snprintf(descp, 255,
-				"Emulex %s %s %s ",
+				"Emulex %s %s %s",
 				m.name, m.bus, m.function);
 		else
 			snprintf(descp, 255,
-- 
1.7.11.7


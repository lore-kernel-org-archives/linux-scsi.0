From: Sebastian Herbszt <herbszt@gmx.de>
Subject: [PATCH] lpfc: Use && instead of & for boolean expression
Date: Wed, 22 Jul 2015 10:53:22 +0200
Message-ID: <20150722105322.00004f4b@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:58242 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064AbbGVIxi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jul 2015 04:53:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <james.smart@avagotech.com>, Sebastian Herbszt <herbszt@gmx.de>

Use logical instead of bitwise AND.

Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>
---

diff -urp a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2015-07-05 22:18:43.933739150 +0200
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2015-07-22 10:31:14.240209475 +0200
@@ -701,7 +701,7 @@ lpfc_work_done(struct lpfc_hba *phba)
 								HA_RXMASK));
 			}
 		}
-		if ((phba->sli_rev == LPFC_SLI_REV4) &
+		if ((phba->sli_rev == LPFC_SLI_REV4) &&
 				 (!list_empty(&pring->txq)))
 			lpfc_drain_txq(phba);
 		/*

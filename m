From: James Smart <james.smart@emulex.com>
Subject: [PATCH 5/19] lpfc 10.4.8000.0: Mark function as static in
 lpfc/lpfc_bsg.c
Date: Wed, 3 Sep 2014 12:55:46 -0400
Message-ID: <1409763346.12357.5.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:47623 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292AbaICQzy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2014 12:55:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Incorporating prior patch:
 http://marc.info/?l=3Dlinux-scsi&m=3D139611670006912&w=3D2

  Rashika Kheria <rashika.kheria@gmail.com>
  [PATCH 26/55] scsi: Mark function as static in lpfc/lpfc_bsg.c

  Mark function as static in lpfc/lpfc_bsg.c because it is not used
  outside this file.

  This eliminates the following warning in lpfc/lpfc_bsg.c:
  drivers/scsi/lpfc/lpfc_bsg.c:3348:1: warning: no previous prototype f=
or =E2=80=98lpfc_bsg_issue_mbox_cmpl=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.=
c
index 5b5c825..371474b 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -3344,7 +3344,7 @@ job_error:
  * will wake up thread waiting on the wait queue pointed by context1
  * of the mailbox.
  **/
-void
+static void
 lpfc_bsg_issue_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 {
 	struct bsg_job_data *dd_data;
--=20
1.7.11.7




--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

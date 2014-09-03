From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/19] lpfc 10.4.8000.0: Mark functions as static in
 lpfc/lpfc_hbadisc.c
Date: Wed, 3 Sep 2014 12:55:17 -0400
Message-ID: <1409763317.12357.2.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:47622 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbaICQzq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2014 12:55:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Incorporating prior patch:
 http://marc.info/?l=3Dlinux-scsi&m=3D139611651106838&w=3D2

  Rashika Kheria <rashika.kheria@gmail.com>
  [PATCH 23/55] scsi: Mark functions as static in lpfc/lpfc_hbadisc.c

  Mark functions as static in lpfc/lpfc_hbadisc.c because they are not
  used outside this file.

  This eliminates the following warnings in lpfc/lpfc_hbadisc.c:
  drivers/scsi/lpfc/lpfc_hbadisc.c:2047:5: warning: no previous prototy=
pe for =E2=80=98lpfc_sli4_fcf_pri_list_add=E2=80=99 [-Wmissing-prototyp=
es]
  drivers/scsi/lpfc/lpfc_hbadisc.c:2681:1: warning: no previous prototy=
pe for =E2=80=98lpfc_init_vfi_cmpl=E2=80=99 [-Wmissing-prototypes]
  drivers/scsi/lpfc/lpfc_hbadisc.c:4432:1: warning: no previous prototy=
pe for =E2=80=98lpfc_nlp_logo_unreg=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_=
hbadisc.c
index 2a17e31..667d124 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -2042,7 +2042,8 @@ lpfc_sli4_set_fcf_flogi_fail(struct lpfc_hba *phb=
a, uint16_t fcf_index)
  * returns:
  * 0=3Dsuccess 1=3Dfailure
  **/
-int lpfc_sli4_fcf_pri_list_add(struct lpfc_hba *phba, uint16_t fcf_ind=
ex,
+static int lpfc_sli4_fcf_pri_list_add(struct lpfc_hba *phba,
+	uint16_t fcf_index,
 	struct fcf_record *new_fcf_record)
 {
 	uint16_t current_fcf_pri;
@@ -2678,7 +2679,7 @@ out:
  *
  * This function handles completion of init vfi mailbox command.
  */
-void
+static void
 lpfc_init_vfi_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 {
 	struct lpfc_vport *vport =3D mboxq->vport;
@@ -4438,7 +4439,7 @@ lpfc_no_rpi(struct lpfc_hba *phba, struct lpfc_no=
delist *ndlp)
  * This function will issue an ELS LOGO command after completing
  * the UNREG_RPI.
  **/
-void
+static void
 lpfc_nlp_logo_unreg(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	struct lpfc_vport  *vport =3D pmb->vport;
--=20
1.7.11.7




--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

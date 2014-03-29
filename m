From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 23/55] scsi: Mark functions as static in lpfc/lpfc_hbadisc.c
Date: Sat, 29 Mar 2014 23:38:38 +0530
Message-ID: <164350d85014181d5a776518b1e04e9fde5a9abd.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: James Smart <james.smart@emulex.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Mark functions as static in lpfc/lpfc_hbadisc.c because they are not
used outside this file.

This eliminates the following warnings in lpfc/lpfc_hbadisc.c:
drivers/scsi/lpfc/lpfc_hbadisc.c:2047:5: warning: no previous prototype=
 for =E2=80=98lpfc_sli4_fcf_pri_list_add=E2=80=99 [-Wmissing-prototypes=
]
drivers/scsi/lpfc/lpfc_hbadisc.c:2681:1: warning: no previous prototype=
 for =E2=80=98lpfc_init_vfi_cmpl=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_hbadisc.c:4432:1: warning: no previous prototype=
 for =E2=80=98lpfc_nlp_logo_unreg=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_=
hbadisc.c
index 883ea2d..0441d50 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -2044,7 +2044,8 @@ lpfc_sli4_set_fcf_flogi_fail(struct lpfc_hba *phb=
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
@@ -2677,7 +2678,7 @@ out:
  *
  * This function handles completion of init vfi mailbox command.
  */
-void
+static void
 lpfc_init_vfi_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 {
 	struct lpfc_vport *vport =3D mboxq->vport;
@@ -4428,7 +4429,7 @@ lpfc_no_rpi(struct lpfc_hba *phba, struct lpfc_no=
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
1.7.9.5

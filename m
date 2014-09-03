From: James Smart <james.smart@emulex.com>
Subject: [PATCH 3/19] lpfc 10.4.8000.0: Mark functions as static in
 lpfc/lpfc_init.c
Date: Wed, 3 Sep 2014 12:55:28 -0400
Message-ID: <1409763328.12357.3.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:47622 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088AbaICQzr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2014 12:55:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Incorporating prior patch:
 http://marc.info/?l=3Dlinux-scsi&m=3D139611657206858&w=3D2

  Rashika Kheria <rashika.kheria@gmail.com>
  [PATCH 24/55] scsi: Mark functions as static in lpfc/lpfc_init.c

  Mark functions as static in lpfc/lpfc_init.c because they are not use=
d
  outside this file.

  This eliminates the following warning in lpfc/lpfc_init.c:
  drivers/scsi/lpfc/lpfc_init.c:652:1: warning: no previous prototype f=
or =E2=80=98lpfc_hba_init_link=E2=80=99 [-Wmissing-prototypes]
  drivers/scsi/lpfc/lpfc_init.c:753:1: warning: no previous prototype f=
or =E2=80=98lpfc_hba_down_link=E2=80=99 [-Wmissing-prototypes]
  drivers/scsi/lpfc/lpfc_init.c:3434:1: warning: no previous prototype =
for =E2=80=98lpfc_sli4_fcf_redisc_wait_tmo=E2=80=99 [-Wmissing-prototyp=
es]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_ini=
t.c
index a5769a9..60d9518 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -649,7 +649,7 @@ lpfc_config_port_post(struct lpfc_hba *phba)
  *		0 - success
  *		Any other value - error
  **/
-int
+static int
 lpfc_hba_init_link(struct lpfc_hba *phba, uint32_t flag)
 {
 	return lpfc_hba_init_link_fc_topology(phba, phba->cfg_topology, flag)=
;
@@ -750,7 +750,7 @@ lpfc_hba_init_link_fc_topology(struct lpfc_hba *phb=
a, uint32_t fc_topology,
  *		0 - success
  *		Any other value - error
  **/
-int
+static int
 lpfc_hba_down_link(struct lpfc_hba *phba, uint32_t flag)
 {
 	LPFC_MBOXQ_t *pmb;
@@ -3550,7 +3550,7 @@ lpfc_fcf_redisc_wait_start_timer(struct lpfc_hba =
*phba)
  * list, and then worker thread shall be waked up for processing from =
the
  * worker thread context.
  **/
-void
+static void
 lpfc_sli4_fcf_redisc_wait_tmo(unsigned long ptr)
 {
 	struct lpfc_hba *phba =3D (struct lpfc_hba *)ptr;
--=20
1.7.11.7




--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

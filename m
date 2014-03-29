From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 25/55] scsi: Mark functions as static in lpfc/lpfc_scsi.c
Date: Sat, 29 Mar 2014 23:41:00 +0530
Message-ID: <5224416254456aaf9e27cc31b070543dda9ff7c9.1396114898.git.rashika.kheria@gmail.com>
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

Mark functions as static in lpfc/lpfc_scsi.c because they are not used
outside this file.

This eliminates the following warnings in lpfc/lpfc_scsi.c:
drivers/scsi/lpfc/lpfc_scsi.c:299:1: warning: no previous prototype for=
 =E2=80=98lpfc_change_queue_depth=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_scsi.c:795:1: warning: no previous prototype for=
 =E2=80=98lpfc_sli4_post_scsi_sgl_list=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_scsi.c:3019:1: warning: no previous prototype fo=
r =E2=80=98lpfc_bg_crc=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_scsi.c:3035:1: warning: no previous prototype fo=
r =E2=80=98lpfc_bg_csum=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_scsi.c:3048:1: warning: no previous prototype fo=
r =E2=80=98lpfc_calc_bg_err=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scs=
i.c
index b2ede05..75844a8e 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -295,7 +295,7 @@ lpfc_send_sdev_queuedepth_change_event(struct lpfc_=
hba *phba,
  * depth for a scsi device. This function sets the queue depth to the =
new
  * value and sends an event out to log the queue depth change.
  **/
-int
+static int
 lpfc_change_queue_depth(struct scsi_device *sdev, int qdepth, int reas=
on)
 {
 	struct lpfc_vport *vport =3D (struct lpfc_vport *) sdev->host->hostda=
ta;
@@ -791,7 +791,7 @@ lpfc_sli4_fcp_xri_aborted(struct lpfc_hba *phba,
  *
  * Returns: 0 =3D failure, non-zero number of successfully posted buff=
ers.
  **/
-int
+static int
 lpfc_sli4_post_scsi_sgl_list(struct lpfc_hba *phba,
 			     struct list_head *post_sblist, int sb_count)
 {
@@ -3015,7 +3015,7 @@ err:
  * on the specified data using a CRC algorithmn
  * using crc_t10dif.
  */
-uint16_t
+static uint16_t
 lpfc_bg_crc(uint8_t *data, int count)
 {
 	uint16_t crc =3D 0;
@@ -3031,7 +3031,7 @@ lpfc_bg_crc(uint8_t *data, int count)
  * on the specified data using a CSUM algorithmn
  * using ip_compute_csum.
  */
-uint16_t
+static uint16_t
 lpfc_bg_csum(uint8_t *data, int count)
 {
 	uint16_t ret;
@@ -3044,7 +3044,7 @@ lpfc_bg_csum(uint8_t *data, int count)
  * This function examines the protection data to try to determine
  * what type of T10-DIF error occurred.
  */
-void
+static void
 lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd=
)
 {
 	struct scatterlist *sgpe; /* s/g prot entry */
--=20
1.7.9.5

From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 35/55] scsi: Mark function as static in pm8001/pm8001_sas.c
Date: Sat, 29 Mar 2014 23:54:07 +0530
Message-ID: <0eeec2c97bdb4944256ec742ca4af14a1f0618dd.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: xjtuwjp@gmail.com, lindar_liu@usish.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Mark function as static in pm8001/pm8001_sas.c because it is not used
outside this file.

This eliminates the following warning in pm8001/pm8001_sas.c:
drivers/scsi/pm8001/pm8001_sas.c:551:23: warning: no previous prototype=
 for =E2=80=98pm8001_alloc_dev=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/pm8001/pm8001_sas.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8=
001_sas.c
index f50ac44..8a82a74 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -548,7 +548,8 @@ void pm8001_ccb_task_free(struct pm8001_hba_info *p=
m8001_ha,
   * pm8001_alloc_dev - find a empty pm8001_device
   * @pm8001_ha: our hba card information
   */
-struct pm8001_device *pm8001_alloc_dev(struct pm8001_hba_info *pm8001_=
ha)
+static struct pm8001_device *pm8001_alloc_dev(struct pm8001_hba_info
+					      *pm8001_ha)
 {
 	u32 dev;
 	for (dev =3D 0; dev < PM8001_MAX_DEVICES; dev++) {
--=20
1.7.9.5

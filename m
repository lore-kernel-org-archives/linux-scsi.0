From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 34/55] scsi: Mark function as static in pm8001/pm8001_init.c
Date: Sat, 29 Mar 2014 23:53:09 +0530
Message-ID: <ca780bfbb7ca9735cc26da4a7556c2bcb686f56b.1396114898.git.rashika.kheria@gmail.com>
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

Mark function as static in pm8001/pm8001_init.c because it is not used
outside this file.

This eliminates the following warning in pm8001/pm8001_init.c:
drivers/scsi/pm8001/pm8001_init.c:677:6: warning: no previous prototype=
 for =E2=80=98pm8001_get_phy_settings_info=E2=80=99 [-Wmissing-prototyp=
es]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/pm8001/pm8001_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm=
8001_init.c
index 73a120d..a82528c 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -674,7 +674,7 @@ static void pm8001_init_sas_add(struct pm8001_hba_i=
nfo *pm8001_ha)
  * pm8001_get_phy_settings_info : Read phy setting values.
  * @pm8001_ha : our hba.
  */
-void pm8001_get_phy_settings_info(struct pm8001_hba_info *pm8001_ha)
+static void pm8001_get_phy_settings_info(struct pm8001_hba_info *pm800=
1_ha)
 {
=20
 #ifdef PM8001_READ_VPD
--=20
1.7.9.5

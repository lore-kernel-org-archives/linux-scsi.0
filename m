From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 36/55] scsi: Mark function as static in pm8001/pm8001_hwi.c
Date: Sat, 29 Mar 2014 23:55:05 +0530
Message-ID: <887c9102d40113374288cc2c6241d87aaf093ead.1396114898.git.rashika.kheria@gmail.com>
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

Mark function as static in pm8001/pm8001_hwi.c because it is not used
outside this file.

This eliminates the following warning in pm8001/pm8001_hwi.c:
drivers/scsi/pm8001/pm8001_hwi.c:4537:5: warning: no previous prototype=
 for =E2=80=98pm8001_chip_phy_stop_req=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8=
001_hwi.c
index 0a1296a..2f8aab1 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4534,7 +4534,7 @@ pm8001_chip_phy_start_req(struct pm8001_hba_info =
*pm8001_ha, u8 phy_id)
  * @num: the inbound queue number
  * @phy_id: the phy id which we wanted to start up.
  */
-int pm8001_chip_phy_stop_req(struct pm8001_hba_info *pm8001_ha,
+static int pm8001_chip_phy_stop_req(struct pm8001_hba_info *pm8001_ha,
 	u8 phy_id)
 {
 	struct phy_stop_req payload;
--=20
1.7.9.5

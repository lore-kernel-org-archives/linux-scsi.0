From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 37/55] scsi: Mark function as static in pm8001/pm80xx_hwi.c
Date: Sat, 29 Mar 2014 23:56:03 +0530
Message-ID: <818bb6b9d6be43bf4a6671bb6d27514d5864fbe3.1396114898.git.rashika.kheria@gmail.com>
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

Mark functions as static in pm8001/pm80xx_hwi.c because they are not
used outside this file.

This eliminates the following warning in pm8001/pm80xx_hwi.c:
drivers/scsi/pm8001/pm80xx_hwi.c:69:6: warning: no previous prototype f=
or =E2=80=98pm80xx_pci_mem_copy=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/pm8001/pm80xx_hwi.c:4529:6: warning: no previous prototype=
 for =E2=80=98mpi_set_phy_profile_req=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm8=
0xx_hwi.c
index c950dc5..156947e 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -66,7 +66,7 @@ int pm80xx_bar4_shift(struct pm8001_hba_info *pm8001_=
ha, u32 shift_value)
 	return 0;
 }
=20
-void pm80xx_pci_mem_copy(struct pm8001_hba_info  *pm8001_ha, u32 soffs=
et,
+static void pm80xx_pci_mem_copy(struct pm8001_hba_info  *pm8001_ha, u3=
2 soffset,
 				const void *destination,
 				u32 dw_count, u32 bus_base_number)
 {
@@ -4526,8 +4526,8 @@ pm80xx_chip_isr(struct pm8001_hba_info *pm8001_ha=
, u8 vec)
 	return IRQ_HANDLED;
 }
=20
-void mpi_set_phy_profile_req(struct pm8001_hba_info *pm8001_ha,
-	u32 operation, u32 phyid, u32 length, u32 *buf)
+static void mpi_set_phy_profile_req(struct pm8001_hba_info *pm8001_ha,
+				u32 operation, u32 phyid, u32 length, u32 *buf)
 {
 	u32 tag , i, j =3D 0;
 	int rc;
--=20
1.7.9.5

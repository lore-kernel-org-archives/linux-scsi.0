From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 05/55] scsi: Mark function as static in bfa/bfa_ioc.c
Date: Sat, 29 Mar 2014 23:17:19 +0530
Message-ID: <4a2fb63485aa5e458af74dd75358d5fa2233c0f2.1396114897.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Anil Gurumurthy <agurumur@brocade.com>, Vijaya Mohan Guvva <vmohan@brocade.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Mark functions as static in bfa/bfa_ioc.c because they are not used
outside this file.

This eliminates the following warning in bfa/bfa_ioc.c:
drivers/scsi/bfa/bfa_ioc.c:5039:1: warning: no previous prototype for =E2=
=80=98bfa_diag_intr=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/bfa/bfa_ioc.c:7002:1: warning: no previous prototype for =E2=
=80=98bfa_flash_sem_get=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/bfa/bfa_ioc.c:7015:1: warning: no previous prototype for =E2=
=80=98bfa_flash_sem_put=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/bfa/bfa_ioc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 65180e1..d9bed12 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -5035,7 +5035,7 @@ diag_portbeacon_comp(struct bfa_diag_s *diag)
 /*
  *	Diag hmbox handler
  */
-void
+static void
 bfa_diag_intr(void *diagarg, struct bfi_mbmsg_s *msg)
 {
 	struct bfa_diag_s *diag =3D diagarg;
@@ -6998,7 +6998,7 @@ bfa_raw_sem_get(void __iomem *bar)
=20
 }
=20
-bfa_status_t
+static bfa_status_t
 bfa_flash_sem_get(void __iomem *bar)
 {
 	u32 n =3D FLASH_BLOCKING_OP_MAX;
@@ -7011,7 +7011,7 @@ bfa_flash_sem_get(void __iomem *bar)
 	return BFA_STATUS_OK;
 }
=20
-void
+static void
 bfa_flash_sem_put(void __iomem *bar)
 {
 	writel(0, (bar + FLASH_SEM_LOCK_REG));
--=20
1.7.9.5

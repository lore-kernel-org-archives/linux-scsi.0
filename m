From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 14/55] scsi: Mark function as static in bnx2fc/bnx2fc_hwi.c
Date: Sat, 29 Mar 2014 23:28:56 +0530
Message-ID: <8c16abbcb9ee06829ac9b528264cfddb316dae2b.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Eddie Wai <eddie.wai@broadcom.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Mark function as static in bnx2fc/bnx2fc_hwi.c because it is not used
outside this file.

This eliminates the following warning in bnx2fc/bnx2fc_hwi.c:
drivers/scsi/bnx2fc/bnx2fc_hwi.c:996:21: warning: no previous prototype=
 for =E2=80=98bnx2fc_alloc_work=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx=
2fc_hwi.c
index 46a3765..7f01cda 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -993,7 +993,7 @@ void bnx2fc_arm_cq(struct bnx2fc_rport *tgt)
=20
 }
=20
-struct bnx2fc_work *bnx2fc_alloc_work(struct bnx2fc_rport *tgt, u16 wq=
e)
+static struct bnx2fc_work *bnx2fc_alloc_work(struct bnx2fc_rport *tgt,=
 u16 wqe)
 {
 	struct bnx2fc_work *work;
 	work =3D kzalloc(sizeof(struct bnx2fc_work), GFP_ATOMIC);
--=20
1.7.9.5

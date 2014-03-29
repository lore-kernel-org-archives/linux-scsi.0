From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 15/55] scsi: Mark function as static in bnx2fc/bnx2fc_io.c
Date: Sat, 29 Mar 2014 23:29:51 +0530
Message-ID: <298b96ea3d7f1ca5b5e91af6d76928f7ff046e4d.1396114898.git.rashika.kheria@gmail.com>
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

Mark function as static in bnx2fc/bnx2fc_io.c because it is not used
outside this file.

This eliminates the following warning in bnx2fc/bnx2fc_io.c:
drivers/scsi/bnx2fc/bnx2fc_io.c:1108:5: warning: no previous prototype =
for =E2=80=98bnx2fc_expl_logo=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2=
fc_io.c
index ed88089..dfa72bf 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1105,7 +1105,7 @@ int bnx2fc_eh_device_reset(struct scsi_cmnd *sc_c=
md)
 	return bnx2fc_initiate_tmf(sc_cmd, FCP_TMF_LUN_RESET);
 }
=20
-int bnx2fc_expl_logo(struct fc_lport *lport, struct bnx2fc_cmd *io_req=
)
+static int bnx2fc_expl_logo(struct fc_lport *lport, struct bnx2fc_cmd =
*io_req)
 {
 	struct bnx2fc_rport *tgt =3D io_req->tgt;
 	struct fc_rport_priv *rdata =3D tgt->rdata;
--=20
1.7.9.5

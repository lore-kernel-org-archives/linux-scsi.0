From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 07/55] scsi: Mark function as static in bfa/bfa_fcs_lport.c
Date: Sat, 29 Mar 2014 23:19:43 +0530
Message-ID: <3f40c168fa91d426705cacbb288949c4447c6d72.1396114897.git.rashika.kheria@gmail.com>
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

Mark function as static in bfa/bfa_fcs_lport.c because it is not used
outside this file.

This eliminates the following warning in bfa/bfa_fcs_lport.c:
drivers/scsi/bfa/bfa_fcs_lport.c:1283:1: warning: no previous prototype=
 for =E2=80=98bfa_fcport_get_loop_attr=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/bfa/bfa_fcs_lport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fc=
s_lport.c
index ff75ef8..0515b01 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -1279,7 +1279,7 @@ bfa_fcs_lport_n2n_offline(struct bfa_fcs_lport_s =
*port)
 	n2n_port->reply_oxid =3D 0;
 }
=20
-void
+static void
 bfa_fcport_get_loop_attr(struct bfa_fcs_lport_s *port)
 {
 	int i =3D 0, j =3D 0, bit =3D 0, alpa_bit =3D 0;
--=20
1.7.9.5

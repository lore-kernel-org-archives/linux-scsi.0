From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 08/55] scsi: Mark function as static in bfa/bfa_port.c
Date: Sat, 29 Mar 2014 23:20:42 +0530
Message-ID: <fbb295b42460bf3f3551b39713fd209dde6e810d.1396114897.git.rashika.kheria@gmail.com>
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

Mark functions as static in bfa/bfa_port.c because they are not used
outside this file.

This eliminates the following warning in bfa/bfa_port.c:
drivers/scsi/bfa/bfa_port.c:776:1: warning: no previous prototype for =E2=
=80=98bfa_cee_isr=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/bfa/bfa_port.c:812:1: warning: no previous prototype for =E2=
=80=98bfa_cee_notify=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/bfa/bfa_port.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_port.c b/drivers/scsi/bfa/bfa_port.c
index 8ea7697..3928a05 100644
--- a/drivers/scsi/bfa/bfa_port.c
+++ b/drivers/scsi/bfa/bfa_port.c
@@ -772,7 +772,7 @@ bfa_cee_reset_stats(struct bfa_cee_s *cee,
  * @return void
  */
=20
-void
+static void
 bfa_cee_isr(void *cbarg, struct bfi_mbmsg_s *m)
 {
 	union bfi_cee_i2h_msg_u *msg;
@@ -808,7 +808,7 @@ bfa_cee_isr(void *cbarg, struct bfi_mbmsg_s *m)
  * @return void
  */
=20
-void
+static void
 bfa_cee_notify(void *arg, enum bfa_ioc_event_e event)
 {
 	struct bfa_cee_s *cee =3D (struct bfa_cee_s *) arg;
--=20
1.7.9.5

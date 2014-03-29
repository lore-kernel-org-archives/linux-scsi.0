From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 10/55] scsi: Mark function as static in bfa/bfa_core.c
Date: Sat, 29 Mar 2014 23:24:39 +0530
Message-ID: <c03c0b1f030192f2ded9f6c6baa42b0be0cb8556.1396114897.git.rashika.kheria@gmail.com>
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

Mark function as static in bfa/bfa_core.c because it is not used outsid=
e
this file.

This eliminates the following warning in bfa/bfa_core.c:
drivers/scsi/bfa/bfa_core.c:716:1: warning: no previous prototype for =E2=
=80=98bfa_isr_rspq=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/bfa/bfa_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index e3f67b0..2a613d2 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -712,7 +712,7 @@ bfa_reqq_resume(struct bfa_s *bfa, int qid)
 	}
 }
=20
-bfa_boolean_t
+static bfa_boolean_t
 bfa_isr_rspq(struct bfa_s *bfa, int qid)
 {
 	struct bfi_msg_s *m;
--=20
1.7.9.5

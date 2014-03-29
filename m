From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 17/55] scsi: Mark function as static in cxgbi/cxgb3i/cxgb3i.c
Date: Sat, 29 Mar 2014 23:32:08 +0530
Message-ID: <93a0ea231762420bb9f6ba69c08e83cb905ce79c.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Rashika Kheria <rashika.kheria@gmail.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Mark function as static in cxgbi/cxgb3i/cxgb3i.c because it is not used
outside this file.

This eliminates the following warning in cxgbi/cxgb3i/cxgb3i.c:
drivers/scsi/cxgbi/cxgb3i/cxgb3i.c:1028:5: warning: no previous prototy=
pe for =E2=80=98cxgb3i_ofld_init=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cx=
gb3i/cxgb3i.c
index 49692a1..6de59c5 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -1025,7 +1025,7 @@ cxgb3_cpl_handler_func cxgb3i_cpl_handlers[NUM_CP=
L_CMDS] =3D {
  * cxgb3i_ofld_init - allocate and initialize resources for each adapt=
er found
  * @cdev:	cxgbi adapter
  */
-int cxgb3i_ofld_init(struct cxgbi_device *cdev)
+static int cxgb3i_ofld_init(struct cxgbi_device *cdev)
 {
 	struct t3cdev *t3dev =3D (struct t3cdev *)cdev->lldev;
 	struct adap_ports port;
--=20
1.7.9.5

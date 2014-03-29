From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 01/55] scsi: Mark function as static in aacraid/src.c
Date: Sat, 29 Mar 2014 21:56:36 +0530
Message-ID: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1394382962.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Mark function as static in aacraid/src.c because it is not used outside
this file.

This eliminates the following warning in aacraid/src.c:
drivers/scsi/aacraid/src.c:526:5: warning: no previous prototype for =E2=
=80=98aac_src_select_comm=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/aacraid/src.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 7e17107..46b1252 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -523,7 +523,7 @@ static int aac_src_restart_adapter(struct aac_dev *=
dev, int bled)
  *	@dev: Adapter
  *	@comm: communications method
  */
-int aac_src_select_comm(struct aac_dev *dev, int comm)
+static int aac_src_select_comm(struct aac_dev *dev, int comm)
 {
 	switch (comm) {
 	case AAC_COMM_MESSAGE:
--=20
1.7.9.5

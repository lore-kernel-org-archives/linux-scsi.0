From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 48/55] scsi: Mark function as static in scsi_debug.c
Date: Sun, 30 Mar 2014 00:14:21 +0530
Message-ID: <bb4a36afee7dd2ac6d2cc58e557876f198cadae1.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Mark function as static in scsi_debug.c because it is not used outside
this file.

This eliminates the following warning in scsi_debug.c:
drivers/scsi/scsi_debug.c:1910:6: warning: no previous prototype for =E2=
=80=98dump_sector=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/scsi_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 2decc64..356b548 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1907,7 +1907,7 @@ static int resp_read(struct scsi_cmnd *SCpnt, uns=
igned long long lba,
 	return 0;
 }
=20
-void dump_sector(unsigned char *buf, int len)
+static void dump_sector(unsigned char *buf, int len)
 {
 	int i, j;
=20
--=20
1.7.9.5

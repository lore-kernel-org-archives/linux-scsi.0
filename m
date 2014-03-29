From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 46/55] scsi: Mark functions as static in gdth.c
Date: Sun, 30 Mar 2014 00:10:53 +0530
Message-ID: <0474b98580d0837b5906973b5d9599c9a9c526b6.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Achim Leubner <achim_leubner@adaptec.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Mark functions as static in gdth.c because they are not used outside
this file.

This eliminates the following warnings in gdth.c:
drivers/scsi/gdth.c:445:5: warning: no previous prototype for =E2=80=98=
__gdth_execute=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/gdth.c:3830:12: warning: no previous prototype for =E2=80=98=
option_setup=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/gdth.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index ce5ef01..8015f1b 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -442,8 +442,8 @@ static void gdth_scsi_done(struct scsi_cmnd *scp)
 		scp->scsi_done(scp);
 }
=20
-int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, cha=
r *cmnd,
-                   int timeout, u32 *info)
+static int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtc=
md,
+			  char *cmnd, int timeout, u32 *info)
 {
     gdth_ha_str *ha =3D shost_priv(sdev->host);
     Scsi_Cmnd *scp;
@@ -3827,7 +3827,7 @@ static void __init internal_setup(char *str,int *=
ints)
     }
 }
=20
-int __init option_setup(char *str)
+static int __init option_setup(char *str)
 {
     int ints[MAXHA];
     char *cur =3D str;
--=20
1.7.9.5

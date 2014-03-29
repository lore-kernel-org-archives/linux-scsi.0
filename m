From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 02/55] scsi: Mark function as static in be2iscsi/be_cmds.c
Date: Sat, 29 Mar 2014 23:13:43 +0530
Message-ID: <e8c6c765e48ea867376850f1bc693f797fa14a53.1396114897.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Mark function as static in be2iscsi/be_cmds.c because it is not used
outside this file.

This eliminates the following warning in be2iscsi/be_cmds.c:
drivers/scsi/be2iscsi/be_cmds.c:401:5: warning: no previous prototype f=
or =E2=80=98beiscsi_process_mcc=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/be2iscsi/be_cmds.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be=
_cmds.c
index 3338391..026c3e3 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -398,7 +398,7 @@ static void beiscsi_cq_notify(struct beiscsi_hba *p=
hba, u16 qid, bool arm,
 }
=20
=20
-int beiscsi_process_mcc(struct beiscsi_hba *phba)
+static int beiscsi_process_mcc(struct beiscsi_hba *phba)
 {
 	struct be_mcc_compl *compl;
 	int num =3D 0, status =3D 0;
--=20
1.7.9.5

From: Wen Yang <wen.yang99@zte.com.cn>
Subject: [PATCH] scsi: qla2xxx: Use PTR_ERR_OR_ZERO to replace the open coded version
Date: Tue, 27 Nov 2018 16:20:27 +0800
Message-ID: <20181127082027.46223-1-wen.yang99@zte.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhong.weidong@zte.com.cn, Wen Yang <wen.yang99@zte.com.cn>, Wen Yang <yellowriver2010@hotmail.com>
List-Id: linux-scsi@vger.kernel.org

PTR=5FERR=5FOR=5FZERO has implemented the same function, so use inlined fun=
ction
instead of open coded equivalent.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
CC: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: qla2xxx-upstream@qlogic.com
CC: linux-scsi@vger.kernel.org
CC: Wen Yang <yellowriver2010@hotmail.com>
CC: linux-kernel@vger.kernel.org
---
 drivers/scsi/qla2xxx/tcm=5Fqla2xxx.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm=5Fqla2xxx.c b/drivers/scsi/qla2xxx/tc=
m=5Fqla2xxx.c
index 65053c066680..633f258085c7 100644
--- a/drivers/scsi/qla2xxx/tcm=5Fqla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm=5Fqla2xxx.c
@@ -1577,10 +1577,7 @@ static int tcm=5Fqla2xxx=5Fcheck=5Finitiator=5Fnode=
=5Facl(
 				       sizeof(struct qla=5Ftgt=5Fcmd),
 				       TARGET=5FPROT=5FALL, port=5Fname,
 				       qlat=5Fsess, tcm=5Fqla2xxx=5Fsession=5Fcb);
-	if (IS=5FERR(se=5Fsess))
-		return PTR=5FERR(se=5Fsess);
-
-	return 0;
+	return PTR=5FERR=5FOR=5FZERO(se=5Fsess);
 }
=20
 static void tcm=5Fqla2xxx=5Fupdate=5Fsess(struct fc=5Fport *sess, port=5Fi=
d=5Ft s=5Fid,
--=20
2.19.1

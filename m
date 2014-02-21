From: Daeseok Youn <daeseok.youn@gmail.com>
Subject: [PATCH] [SCSI] be2iscsi: make beiscsi_process_mcc() as static
Date: Fri, 21 Feb 2014 10:11:40 +0900
Message-ID: <4848622.esnnEkYuHI@daeseok-laptop.cloud.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: jayamohan.kallickal@emulex.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>From 137a2f619f1fa93fc497d891954d83c6cb307d11 Mon Sep 17 00:00:00 2001
From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Fri, 21 Feb 2014 08:43:56 +0900
Subject: [PATCH] [SCSI] be2iscsi: make beiscsi_process_mcc() as static

beiscsi_process_mcc() is only referenced in this file.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 1ec9793..d4fff8a 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -398,7 +398,7 @@ static void beiscsi_cq_notify(struct beiscsi_hba *phba, u16 qid, bool arm,
 }
 
 
-int beiscsi_process_mcc(struct beiscsi_hba *phba)
+static int beiscsi_process_mcc(struct beiscsi_hba *phba)
 {
 	struct be_mcc_compl *compl;
 	int num = 0, status = 0;
-- 
1.7.9.5

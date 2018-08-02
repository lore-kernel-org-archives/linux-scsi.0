From: zhong jiang <zhongjiang@huawei.com>
Subject: [PATCH 2/2] scsi:qlogicfas408: remove the same check in qlogicfas408_detect
Date: Thu, 2 Aug 2018 10:45:01 +0800
Message-ID: <1533177901-19514-3-git-send-email-zhongjiang@huawei.com>
References: <1533177901-19514-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533177901-19514-1-git-send-email-zhongjiang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: andy.shevchenko@gmail.com, john.garry@huawei.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, aacraid@microsemi.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

we should not use same check in a expression. just remove one
of them.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/scsi/qlogicfas408.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
index 8b471a9..1409ac1 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -567,8 +567,7 @@ void qlogicfas408_setup(int qbase, int id, int int_type)
 int qlogicfas408_detect(int qbase, int int_type)
 {
         REG1;
-	return (((inb(qbase + 0xe) ^ inb(qbase + 0xe)) == 7) &&
-	       ((inb(qbase + 0xe) ^ inb(qbase + 0xe)) == 7));		
+	return (inb(qbase + 0xe) ^ inb(qbase + 0xe)) == 7;
 }
 
 /*
-- 
1.7.12.4

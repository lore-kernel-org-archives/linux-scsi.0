From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH] scsi: qedf: NULL check before some freeing functions is
 not needed.
Date: Sun, 02 Dec 2018 21:52:11 +0100
Message-ID: <1543760930052-271366275-12-diffsplit-thomas@m3y3r.de>
References: <1543760930050-1499171309-0-diffsplit-thomas@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1543760930050-1499171309-0-diffsplit-thomas@m3y3r.de>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@cavium.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

NULL check before some freeing functions is not needed.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2935,8 +2935,7 @@ static void qedf_free_fcoe_pf_param(stru
 
 	qedf_free_global_queues(qedf);
 
-	if (qedf->global_queues)
-		kfree(qedf->global_queues);
+	kfree(qedf->global_queues);
 }
 
 /*

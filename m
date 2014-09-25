From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 01/19] qla2xxx: Fix sparse warnings in tcm_qla2xxx.c
Date: Thu, 25 Sep 2014 04:09:54 -0400
Message-ID: <1411632612-7320-2-git-send-email-saurav.kashyap@qlogic.com>
References: <1411632612-7320-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:5266 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391AbaIYIoM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 04:44:12 -0400
In-Reply-To: <1411632612-7320-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com

From: Himanshu Madhani <himanshu.madhani@qlogic.com>

Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index e2beab9..09d2931 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -50,8 +50,12 @@
 #include "qla_target.h"
 #include "tcm_qla2xxx.h"
 
-struct workqueue_struct *tcm_qla2xxx_free_wq;
-struct workqueue_struct *tcm_qla2xxx_cmd_wq;
+static struct workqueue_struct *tcm_qla2xxx_free_wq;
+static struct workqueue_struct *tcm_qla2xxx_cmd_wq;
+
+/* Local pointer to allocated TCM configfs fabric module */
+static struct target_fabric_configfs *tcm_qla2xxx_fabric_configfs;
+static struct target_fabric_configfs *tcm_qla2xxx_npiv_fabric_configfs;
 
 /*
  * Parse WWN.
@@ -734,10 +738,6 @@ static void tcm_qla2xxx_aborted_task(struct se_cmd *se_cmd)
 	cmd->sg_mapped = 0;
 }
 
-/* Local pointer to allocated TCM configfs fabric module */
-struct target_fabric_configfs *tcm_qla2xxx_fabric_configfs;
-struct target_fabric_configfs *tcm_qla2xxx_npiv_fabric_configfs;
-
 static void tcm_qla2xxx_clear_sess_lookup(struct tcm_qla2xxx_lport *,
 			struct tcm_qla2xxx_nacl *, struct qla_tgt_sess *);
 /*
-- 
1.7.7


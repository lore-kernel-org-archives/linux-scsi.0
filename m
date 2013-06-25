From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 03/16] qla2xxx: Move qla2x00_free_device to the correct location.
Date: Tue, 25 Jun 2013 11:27:18 -0400
Message-ID: <1372174051-4211-4-git-send-email-saurav.kashyap@qlogic.com>
References: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:3897 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123Ab3FYPxv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jun 2013 11:53:51 -0400
Received: from mail147-co9 (localhost [127.0.0.1])	by
 mail147-co9-R.bigfish.com (Postfix) with ESMTP id 0CD7B540393	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:50 +0000 (UTC)
Received: from CO9EHSMHS023.bigfish.com (unknown [10.236.132.235])	by
 mail147-co9.bigfish.com (Postfix) with ESMTP id D7021C40060	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:47 +0000 (UTC)
In-Reply-To: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ad72c1d..c2e2e20 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -104,8 +104,6 @@ MODULE_PARM_DESC(ql2xshiftctondsd,
 		"Set to control shifting of command type processing "
 		"based on total number of SG elements.");
 
-static void qla2x00_free_device(scsi_qla_host_t *);
-
 int ql2xfdmienable=1;
 module_param(ql2xfdmienable, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xfdmienable,
@@ -237,6 +235,7 @@ static int qla2xxx_eh_host_reset(struct scsi_cmnd *);
 
 static int qla2x00_change_queue_depth(struct scsi_device *, int, int);
 static int qla2x00_change_queue_type(struct scsi_device *, int);
+static void qla2x00_free_device(scsi_qla_host_t *);
 
 struct scsi_host_template qla2xxx_driver_template = {
 	.module			= THIS_MODULE,
-- 
1.7.7



From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 19/35] qla2xxx: Allow user to change ql2xfdmienable value.
Date: Thu, 25 Sep 2014 05:16:50 -0400
Message-ID: <1411636626-7566-20-git-send-email-saurav.kashyap@qlogic.com>
References: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:13405 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753048AbaIYJvW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 05:51:22 -0400
In-Reply-To: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Himanshu Madhani <himanshu.madhani@qlogic.com>

Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1b9864c..0f9dcf6 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -105,7 +105,7 @@ MODULE_PARM_DESC(ql2xshiftctondsd,
 		"based on total number of SG elements.");
 
 int ql2xfdmienable=1;
-module_param(ql2xfdmienable, int, S_IRUGO);
+module_param(ql2xfdmienable, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xfdmienable,
 		"Enables FDMI registrations. "
 		"0 - no FDMI. Default is 1 - perform FDMI.");
-- 
1.7.7


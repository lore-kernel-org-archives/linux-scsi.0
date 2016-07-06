From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 05/19] qla2xxx: Add module parameter alternate/short names.
Date: Wed, 6 Jul 2016 11:14:21 -0400
Message-ID: <1467818075-15246-6-git-send-email-himanshu.madhani@qlogic.com>
References: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:21514 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754730AbcGFP7z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 11:59:55 -0400
In-Reply-To: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index dc608ce..f1a2394 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -80,6 +80,7 @@ MODULE_PARM_DESC(ql2xallocfwdump,
 
 int ql2xextended_error_logging;
 module_param(ql2xextended_error_logging, int, S_IRUGO|S_IWUSR);
+module_param_named(logging, ql2xextended_error_logging, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xextended_error_logging,
 		"Option to enable extended error logging,\n"
 		"\t\tDefault is 0 - no logging.  0x40000000 - Module Init & Probe.\n"
@@ -106,6 +107,7 @@ MODULE_PARM_DESC(ql2xshiftctondsd,
 
 int ql2xfdmienable=1;
 module_param(ql2xfdmienable, int, S_IRUGO|S_IWUSR);
+module_param_named(fdmi, ql2xfdmienable, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xfdmienable,
 		"Enables FDMI registrations. "
 		"0 - no FDMI. Default is 1 - perform FDMI.");
@@ -157,6 +159,7 @@ MODULE_PARM_DESC(ql2xmultique_tag,
 
 int ql2xfwloadbin;
 module_param(ql2xfwloadbin, int, S_IRUGO|S_IWUSR);
+module_param_named(fwload, ql2xfwloadbin, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xfwloadbin,
 		"Option to specify location from which to load ISP firmware:.\n"
 		" 2 -- load firmware via the request_firmware() (hotplug).\n"
-- 
2.7.2

